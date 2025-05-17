import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matka_game_app/repositories/user_repository.dart';
import 'package:matka_game_app/services/user_service.dart';
import 'package:matka_game_app/utils/user_role.dart';
import 'package:matka_game_app/widgets/gradient_button.dart';

class UserFormScreen extends StatefulWidget {
  const UserFormScreen(this.repository, {super.key, required this.user});

  final UserData user;
  final UserRepository repository;

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _loading = false;
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Details"),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.close : Icons.edit),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
                if (!_isEditing) {
                  _formKey.currentState?.reset();
                }
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: FormBuilder(
            key: _formKey,
            initialValue: {
              'email': widget.user.email,
              'fullName': widget.user.fullName,
              'phoneNumber': widget.user.phoneNumber,
              'role': widget.user.role,
              'upiId': widget.user.upiId,
              'bankAccountNumber': widget.user.bankDetails.accountNumber,
              'bankIfscCode': widget.user.bankDetails.ifscCode,
              'bankName': widget.user.bankDetails.bankName,
              'accountHolderName': widget.user.bankDetails.accountHolderName,
              'balance': widget.user.balance.toString(),
              'isActive': widget.user.isActive,
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSection(
                  'Basic Information',
                  [
                    _buildTextField(
                      'email',
                      'Email',
                      enabled: false,
                      prefixIcon: CupertinoIcons.mail,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      'fullName',
                      'Full Name',
                      enabled: _isEditing,
                      prefixIcon: CupertinoIcons.person_fill,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.minLength(3),
                      ]) as FormFieldValidator<String>?,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      'phoneNumber',
                      'Phone Number',
                      enabled: _isEditing,
                      prefixIcon: CupertinoIcons.phone_fill,
                      keyboardType: TextInputType.phone,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.numeric(),
                        FormBuilderValidators.minLength(10),
                      ]) as FormFieldValidator<String>?,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSection(
                  'Role',
                  [
                    FormBuilderDropdown<UserRole>(
                      name: 'role',
                      enabled: _isEditing,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(CupertinoIcons.person_2_fill),
                        hintText: "Role",
                        hintStyle: GoogleFonts.poppins(
                          color: Colors.grey.shade800,
                          fontSize: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                      ),
                      items: UserRole.values
                          .map(
                            (role) => DropdownMenuItem(
                              value: role,
                              child: Text(role.name),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSection(
                  'Wallet & Status',
                  [
                    _buildTextField(
                      'balance',
                      'Wallet Balance',
                      enabled: _isEditing,
                      prefixIcon: CupertinoIcons.money_dollar_circle_fill,
                      keyboardType: TextInputType.number,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.numeric(),
                      ]) as FormFieldValidator<String>?,
                    ),
                    const SizedBox(height: 16),
                    FormBuilderSwitch(
                      name: 'isActive',
                      enabled: _isEditing,
                      title: Text(
                        'Active Status',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSection(
                  'Payment Information',
                  [
                    _buildTextField(
                      'upiId',
                      'UPI ID',
                      enabled: _isEditing,
                      prefixIcon: CupertinoIcons.creditcard_fill,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      'bankAccountNumber',
                      'Bank Account Number',
                      enabled: _isEditing,
                      prefixIcon: CupertinoIcons.creditcard_fill,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      'bankIfscCode',
                      'Bank IFSC Code',
                      enabled: _isEditing,
                      prefixIcon: CupertinoIcons.creditcard_fill,
                      textCapitalization: TextCapitalization.characters,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      'bankName',
                      'Bank Name',
                      enabled: _isEditing,
                      prefixIcon: CupertinoIcons.building_2_fill,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      'accountHolderName',
                      'Account Holder Name',
                      enabled: _isEditing,
                      prefixIcon: CupertinoIcons.person_fill,
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                if (_isEditing) ...[
                  GradientButton(
                    onTap: _saveChanges,
                    child: Text(
                      _loading ? "Saving..." : "Save Changes",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildTextField(
    String name,
    String label, {
    bool enabled = true,
    IconData? prefixIcon,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    FormFieldValidator<String>? validator,
  }) {
    return FormBuilderTextField(
      name: name,
      enabled: enabled,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        labelText: label,
        labelStyle: GoogleFonts.poppins(
          color: Colors.grey.shade800,
          fontSize: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFcd1b65)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade300),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade300),
        ),
      ),
    );
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      try {
        setState(() {
          _loading = true;
        });

        final formData = _formKey.currentState!.value;
        final updatedUser = widget.user.copyWith(
          fullName: formData['fullName'],
          phoneNumber: formData['phoneNumber'],
          role: formData['role'],
          upiId: formData['upiId'],
          balance: double.parse(formData['balance']),
          isActive: formData['isActive'],
          bankDetails: BankDetails(
            accountNumber: formData['bankAccountNumber'],
            ifscCode: formData['bankIfscCode'],
            bankName: formData['bankName'],
            accountHolderName: formData['accountHolderName'],
          ),
        );

        await widget.repository.updateUser(updatedUser);

        setState(() {
          _isEditing = false;
        });

        Get.snackbar(
          "Success",
          "Profile updated successfully!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } on FirebaseException catch (e) {
        Get.snackbar(
          "Error",
          e.message ?? "An error occurred!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        setState(() {
          _loading = false;
        });
      }
    }
  }
}
