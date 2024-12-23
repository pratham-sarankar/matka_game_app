import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matka_game_app/models/wallet_transaction.dart';
import 'package:matka_game_app/repositories/wallet_repository.dart';
import 'package:matka_game_app/utils/widget_list.dart';
import 'package:matka_game_app/widgets/file_picker_form_field.dart';
import 'package:matka_game_app/widgets/gradient_button.dart';
import 'package:path/path.dart';

class TransactionForm extends StatefulWidget {
  const TransactionForm({super.key, this.transaction});

  final WalletTransaction? transaction;

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _formKey = GlobalKey<FormState>();
  late WalletTransaction _transaction;
  bool _isLoading = false;

  @override
  void initState() {
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Request"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
          children: [
            // Amount Field
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Amount",
                hintText: "Enter amount",
                prefixIcon: Icon(Icons.currency_rupee),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter amount";
                } else if (double.tryParse(value) == null) {
                  return "Please enter valid amount";
                }
                return null;
              },
              onSaved: (newValue) {
                _transaction.amount = double.parse(newValue!);
              },
            ),
            // Type Field
            DropdownButtonFormField<String>(
              items: WalletTransactionTypeExtension.dropDownItems,
              value: _transaction.type.name,
              onChanged: (newValue) {
                setState(() {
                  _transaction.type =
                      WalletTransactionTypeExtension.fromString(newValue!);
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please select type";
                }
                return null;
              },
              onSaved: (newValue) {
                _transaction.type =
                    WalletTransactionTypeExtension.fromString(newValue!);
              },
              decoration: const InputDecoration(
                labelText: "Type",
                hintText: "Select Type",
                prefixIcon: Icon(Icons.account_tree_rounded),
              ),
            ),
            // Note Field
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Note",
                hintText: "Enter Note",
                prefixIcon: Icon(Icons.notes),
              ),
              onSaved: (newValue) {
                _transaction.note = newValue!;
              },
            ),
            // File Picker Form Field
            if (_transaction.type == WalletTransactionType.deposit)
              FilePickerFormField(
                onSaved: (newValue) {},
                onChanged: (File? file) async {
                  if (file != null) {
                    final url = await _uploadFile(context, file);
                    _transaction.mediaURL = url;
                  }
                },
              ),
            const SizedBox(height: 5),
            // Submit Button
            GradientButton(
              onTap: _submit,
              child: Center(
                child: Text(
                  _isLoading ? "Loading..." : "Submit",
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ].withPadding(const EdgeInsets.only(bottom: 15)),
        ),
      ),
    );
  }

  void _submit() async {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await WalletRepository().addTransaction(_transaction);
    }
    setState(() {
      _isLoading = false;
    });
    Get.back();
  }

  Future<String> _uploadFile(BuildContext context, File file) async {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text("Uploading File"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text("Please wait while we upload the file"),
            ],
          ),
        );
      },
    );
    final url = await _uploadFileToFirebase(file);
    Get.back();
    return url;
  }

  Future<String> _uploadFileToFirebase(File file) async {
    // Upload file to firebase
    final user = FirebaseAuth.instance.currentUser!;
    final now = DateTime.now().microsecondsSinceEpoch;
    final ref = FirebaseStorage.instance
        .ref("files/${user.uid}/$now/${basename(file.path)}");
    final result = await ref.putFile(file);
    final url = await result.ref.getDownloadURL();
    return url;
  }
}
