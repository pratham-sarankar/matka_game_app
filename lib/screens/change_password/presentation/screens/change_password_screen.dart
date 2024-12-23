import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matka_game_app/services/user_service.dart';
import 'package:matka_game_app/widgets/gradient_button.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen(this.userService, {super.key});

  final UserService userService;

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
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
        title: const Text("Change Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              "Forgot your password? No worries! Just click the button below "
              "to receive a password reset email.",
            ),
            const SizedBox(height: 20),
            GradientButton(
              onTap: _sendResetEmail,
              child: Text(
                _loading ? "Loading..." : "Request Password Reset Email",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendResetEmail() async {
    try {
      setState(() {
        _loading = true;
      });
      await widget.userService.sendPasswordResetEmail();
      Get.snackbar("Success",
          "A password reset email has been sent to your email address.");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }
}
