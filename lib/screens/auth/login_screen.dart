import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:get/get.dart';
import 'package:matka_game_app/navigation/routes.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Stack(
        children: [
          SignInScreen(
            providers: [
              EmailAuthProvider(),
            ],
            showPasswordVisibilityToggle: true,
            subtitleBuilder: (context, action) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: action == AuthAction.signIn
                    ? const Text(
                        'Welcome back! Please sign in to continue.',
                      )
                    : const Text(
                        'Please create an account to continue.',
                      ),
              );
            },
            footerBuilder: (context, action) {
              return Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  action == AuthAction.signIn
                      ? 'By signing in, you agree to our terms of service and privacy policy.'
                      : 'By registering, you agree to our terms of service and privacy policy.',
                  textAlign: TextAlign.center,
                ),
              );
            },
            actions: [
              AuthStateChangeAction<SignedIn>(
                (context, state) => Get.offAllNamed(Routes.home),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
