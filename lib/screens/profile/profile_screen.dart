import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matka_game_app/services/user_service.dart';
import 'package:matka_game_app/widgets/gradient_button.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _userService = Get.find<UserService>();
  bool _isEditing = false;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
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
      body: Obx(() {
        final user = _userService.userData.value;
        if (user == null)
          return const Center(child: CircularProgressIndicator());

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: FormBuilder(
              key: _formKey,
              initialValue: {
                'email': user.email,
                'fullName': user.fullName,
                'phoneNumber': user.phoneNumber,
                'upiId': user.upiId,
                'bankAccountNumber': user.bankDetails.accountNumber,
                'bankIfscCode': user.bankDetails.ifscCode,
                'bankName': user.bankDetails.bankName,
                'accountHolderName': user.bankDetails.accountHolderName,
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: const Color(0xFFcd1b65),
                      child: Text(
                        user.fullName.isNotEmpty
                            ? user.fullName[0].toUpperCase()
                            : '?',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildSection(
                    'Personal Information',
                    [
                      FormBuilderTextField(
                        name: 'email',
                        enabled: false,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email),
                          hintText: "Email",
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
                      ),
                      const SizedBox(height: 16),
                      FormBuilderTextField(
                        name: 'fullName',
                        enabled: _isEditing,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person),
                          hintText: "Full Name",
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
                      ),
                      const SizedBox(height: 16),
                      FormBuilderTextField(
                        name: 'phoneNumber',
                        enabled: _isEditing,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.numeric(),
                          FormBuilderValidators.minLength(10),
                          FormBuilderValidators.maxLength(10),
                        ]),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.phone),
                          hintText: "Phone Number",
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
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    'Payment Information',
                    [
                      FormBuilderTextField(
                        name: 'upiId',
                        enabled: _isEditing,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.account_balance_wallet),
                          hintText: "UPI ID",
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
                      ),
                      const SizedBox(height: 16),
                      FormBuilderTextField(
                        name: 'bankName',
                        enabled: _isEditing,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.account_balance),
                          hintText: "Bank Name",
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
                      ),
                      const SizedBox(height: 16),
                      FormBuilderTextField(
                        name: 'accountHolderName',
                        enabled: _isEditing,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person_outline),
                          hintText: "Account Holder Name",
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
                      ),
                      const SizedBox(height: 16),
                      FormBuilderTextField(
                        name: 'bankAccountNumber',
                        enabled: _isEditing,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.numeric(),
                          FormBuilderValidators.minLength(9),
                          FormBuilderValidators.maxLength(18),
                        ]),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.credit_card),
                          hintText: "Account Number",
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
                      ),
                      const SizedBox(height: 16),
                      FormBuilderTextField(
                        name: 'bankIfscCode',
                        enabled: _isEditing,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.minLength(11),
                          FormBuilderValidators.maxLength(11),
                        ]),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.code),
                          hintText: "IFSC Code",
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
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  if (_isEditing)
                    GradientButton(
                      onTap: _loading ? null : _saveChanges,
                      child: _loading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text('Save Changes'),
                    ),
                ],
              ),
            ),
          ),
        );
      }),
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

  Future<void> _saveChanges() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      try {
        setState(() {
          _loading = true;
        });

        final formData = _formKey.currentState!.value;
        final user = _userService.userData.value!;
        final updatedUser = user.copyWith(
          fullName: formData['fullName'],
          phoneNumber: formData['phoneNumber'],
          upiId: formData['upiId'],
          bankDetails: BankDetails(
            accountNumber: formData['bankAccountNumber'],
            ifscCode: formData['bankIfscCode'],
            bankName: formData['bankName'],
            accountHolderName: formData['accountHolderName'],
          ),
        );

        await _userService.updateUserData(updatedUser);

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
      } catch (e) {
        Get.snackbar(
          "Error",
          e.toString(),
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
