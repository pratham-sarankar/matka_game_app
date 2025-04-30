import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matka_game_app/repositories/user_repository.dart';
import 'package:matka_game_app/screens/users/widgets/block_user_button.dart';
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
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Details"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              Text(
                "User Details",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField(
                value: widget.user.role,
                items: UserTypeExtension.dropDownItems,
                onSaved: (newValue) {
                  widget.user.role = newValue;
                },
                onChanged: (value) {},
                decoration: InputDecoration(
                  prefixIcon: const Icon(CupertinoIcons.person_fill),
                  hintText: "Role",
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.grey.shade800,
                    fontSize: 18,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: widget.user.fullName,
                keyboardType: TextInputType.number,
                onSaved: (newValue) {
                  widget.user.fullName = newValue!;
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(CupertinoIcons.person_fill),
                  hintText: "Full Name",
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.grey.shade800,
                    fontSize: 18,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: widget.user.phoneNumber,
                onSaved: (newValue) {
                  widget.user.phoneNumber = newValue!;
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(CupertinoIcons.phone_fill),
                  hintText: "Phone Number",
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.grey.shade800,
                    fontSize: 18,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Wallet",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: widget.user.balance.toString(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a value.";
                  }
                  final parsed = double.tryParse(value);
                  if (parsed == null) {
                    return "Please enter a valid number.";
                  }
                  return null;
                },
                onSaved: (newValue) {
                  widget.user.balance = double.parse(newValue!);
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.currency_rupee),
                  hintText: "Wallet Balance",
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.grey.shade800,
                    fontSize: 18,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Payment Details",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: widget.user.upiId,
                onSaved: (newValue) {
                  widget.user.upiId = newValue!;
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.wallet),
                  hintText: "UPI ID",
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.grey.shade800,
                    fontSize: 18,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Bank Details",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: widget.user.bankAccNumber,
                onSaved: (newValue) {
                  widget.user.bankAccNumber = newValue!;
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.account_box),
                  hintText: "Bank Account Number",
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.grey.shade800,
                    fontSize: 18,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: widget.user.bankIfscCode,
                onSaved: (newValue) {
                  widget.user.bankIfscCode = newValue!;
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.account_tree_rounded),
                  hintText: "Bank IFSC Code",
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.grey.shade800,
                    fontSize: 18,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: widget.user.accountHolderName,
                onSaved: (newValue) {
                  widget.user.accountHolderName = newValue!;
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person),
                  hintText: "Account Holder Name",
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.grey.shade800,
                    fontSize: 18,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: widget.user.bankName,
                onSaved: (newValue) {
                  widget.user.bankName = newValue!;
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.account_balance),
                  hintText: "Bank Name",
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.grey.shade800,
                    fontSize: 18,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: GradientButton(
                  child: Text(
                    _loading ? "Loading..." : "Submit",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  onTap: () async {
                    try {
                      setState(() {
                        _loading = true;
                      });
                      if (_formKey.currentState?.validate() ?? false) {
                        _formKey.currentState?.save();
                        await widget.repository.updateUser(widget.user);
                        Get.snackbar(
                          "Success",
                          "Profile updated successfully!",
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    } on FirebaseException catch (e) {
                      Get.snackbar(
                        "Error",
                        e.message ?? "An error occurred!",
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    } finally {
                      setState(() {
                        _loading = false;
                      });
                    }
                  },
                ),
              ),
              BlockUserButton(
                widget.user,
                repository: widget.repository,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
