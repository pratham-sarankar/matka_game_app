import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:firebase_ui_storage/firebase_ui_storage.dart';
import 'package:matka_game_app/models/wallet_transaction.dart';
import 'package:matka_game_app/repositories/wallet_repository.dart';
import 'package:matka_game_app/utils/errors/request_limit_exception.dart';
import 'package:matka_game_app/utils/widget_list.dart';
import 'package:matka_game_app/widgets/gradient_button.dart';

/// A form screen for creating or editing wallet transactions.
///
/// This screen allows users to:
/// - Enter transaction amount
/// - Select transaction type (deposit/withdrawal)
/// - Add a note
/// - Upload media for deposit transactions
class TransactionForm extends StatefulWidget {
  const TransactionForm({super.key, this.transaction});

  /// Optional existing transaction to edit
  final WalletTransaction? transaction;

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  // Form key for validation and state management
  final _formKey = GlobalKey<FormBuilderState>();

  // Repository for handling transaction operations
  final _repository = WalletRepository();

  // Current transaction being edited/created
  late WalletTransaction _transaction;

  // Loading state for async operations
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeTransaction();
  }

  @override
  Widget build(BuildContext context) {
    return FirebaseUIStorageConfigOverride(
      config: FirebaseUIStorageConfiguration(
        uploadRoot: FirebaseStorage.instance.ref('payment_proofs'),
        namingPolicy: UuidFileUploadNamingPolicy(),
        storage: FirebaseStorage.instance,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add Request"),
        ),
        body: FormBuilder(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
          child: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            children: [
              _buildImagePreview(),
              _buildAmountField(),
              _buildTypeField(),
              _buildNoteField(),
              if (_transaction.type == WalletTransactionType.deposit &&
                  _transaction.mediaURL == null)
                _buildMediaUploadField(),
              _buildSubmitButton(),
            ].withPadding(const EdgeInsets.only(bottom: 15)),
          ),
        ),
      ),
    );
  }

  /// Initializes the transaction object based on whether we're editing or creating
  void _initializeTransaction() {
    if (widget.transaction != null) {
      _transaction = widget.transaction!;
    } else {
      final user = FirebaseAuth.instance.currentUser;
      _transaction = WalletTransaction(
        id: "",
        userID: user!.uid,
        amount: 0,
        type: WalletTransactionType.withdrawal,
        note: "",
        status: WalletTransactionStatus.pending,
      );
    }
  }

  /// Handles the form submission
  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      setState(() => _isLoading = true);
      try {
        await _repository.addWalletTransaction(_transaction);
        if (mounted) {
          Navigator.of(context).pop();
        }
      } on RequestLimitException catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  /// Updates the transaction amount from form input
  void _updateAmount(String? value) {
    if (value != null && value.isNotEmpty) {
      _transaction.amount = double.parse(value);
    }
  }

  /// Updates the transaction type from form input
  void _updateType(String? value) {
    if (value != null) {
      setState(() {
        _transaction.type = WalletTransactionTypeExtension.fromString(value);
      });
    }
  }

  /// Updates the transaction note from form input
  void _updateNote(String? value) {
    if (value != null) {
      _transaction.note = value;
    }
  }

  /// Handles media upload completion
  Future<void> _handleUploadComplete(Reference ref) async {
    final url = await ref.getDownloadURL();
    if (mounted) {
      setState(() {
        _transaction.mediaURL = url;
        _isLoading = false;
      });
    }
  }

  /// Builds image preview
  Widget _buildImagePreview() {
    if (_transaction.mediaURL == null) {
      return const SizedBox.shrink();
    }
    return Row(
      children: [
        Expanded(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.network(_transaction.mediaURL!),
          ),
        ),
        IconButton(
          icon: const Icon(CupertinoIcons.delete, color: Colors.red),
          onPressed: _onDeleteImage,
        ),
      ],
    );
  }

  /// Builds the amount input field
  Widget _buildAmountField() {
    return FormBuilderTextField(
      name: 'amount',
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: "Amount",
        hintText: "Enter amount",
        prefixIcon: Icon(Icons.currency_rupee),
      ),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(),
        FormBuilderValidators.numeric(),
      ]),
      onSaved: _updateAmount,
    );
  }

  /// Builds the transaction type dropdown field
  Widget _buildTypeField() {
    return FormBuilderDropdown<String>(
      name: 'type',
      items: WalletTransactionTypeExtension.dropDownItems,
      initialValue: _transaction.type.name,
      onChanged: _updateType,
      validator: FormBuilderValidators.required(),
      decoration: const InputDecoration(
        labelText: "Type",
        hintText: "Select Type",
        prefixIcon: Icon(Icons.account_tree_rounded),
      ),
    );
  }

  /// Builds the note input field
  Widget _buildNoteField() {
    return FormBuilderTextField(
      name: 'note',
      decoration: const InputDecoration(
        labelText: "Note",
        hintText: "Enter Note",
        prefixIcon: Icon(Icons.notes),
      ),
      onSaved: _updateNote,
    );
  }

  /// Builds the media upload field for deposit transactions
  Widget _buildMediaUploadField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: UploadButton(
        onError: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error uploading file: $error')),
          );
        },
        onUploadStarted: (task) {
          setState(() => _isLoading = true);
        },
        onUploadComplete: _handleUploadComplete,
        variant: ButtonVariant.filled,
        storage: FirebaseStorage.instance,
      ),
    );
  }

  /// Builds the submit button
  Widget _buildSubmitButton() {
    return GradientButton(
      onTap: !_isLoading ? _submit : () {},
      child: Center(
        child: Text(
          _isLoading ? "Loading..." : "Submit",
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  /// Handles image deletion
  void _onDeleteImage() async {
    setState(() => _isLoading = true);
    try {
      // Delete from Firebase Storage
      final ref = FirebaseStorage.instance.refFromURL(_transaction.mediaURL!);
      await ref.delete();

      // Update state
      if (mounted) {
        setState(() {
          _transaction.mediaURL = null;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting image: $e')),
        );
        setState(() => _isLoading = false);
      }
    }
  }
}
