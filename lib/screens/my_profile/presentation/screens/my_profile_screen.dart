import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matka_game_app/services/user_service.dart';
import 'package:matka_game_app/widgets/gradient_button.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen(this.userService, {super.key});

  final UserService userService;

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            CupertinoIcons.arrow_left,
            size: 25,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text("My Profile"),
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
              TextFormField(
                initialValue: widget.userService.userData.value.fullName,
                onSaved: (newValue) {
                  widget.userService.userData.value.fullName = newValue!;
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
                initialValue: widget.userService.userData.value.phoneNumber,
                onSaved: (newValue) {
                  widget.userService.userData.value.phoneNumber = newValue!;
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
                "Payment Details",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: widget.userService.userData.value.upiId,
                onSaved: (newValue) {
                  widget.userService.userData.value.upiId = newValue!;
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
                initialValue: widget.userService.userData.value.bankAccNumber,
                onSaved: (newValue) {
                  widget.userService.userData.value.bankAccNumber = newValue!;
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
                initialValue: widget.userService.userData.value.bankIfscCode,
                onSaved: (newValue) {
                  widget.userService.userData.value.bankIfscCode = newValue!;
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
                initialValue:
                    widget.userService.userData.value.accountHolderName,
                onSaved: (newValue) {
                  widget.userService.userData.value.accountHolderName =
                      newValue!;
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
                initialValue: widget.userService.userData.value.bankName,
                onSaved: (newValue) {
                  widget.userService.userData.value.bankName = newValue!;
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
                        final data = widget.userService.userData.value;
                        await widget.userService.updateUserData(data);
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
            ],
          ),
        ),
      ),
    );
  }
}
