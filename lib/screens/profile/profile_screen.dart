import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:get/get.dart';
import 'package:matka_game_app/navigation/routes.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProfileScreen(
        appBar: AppBar(
          title: const Text('My Profile'),
          centerTitle: false,
        ),
        showMFATile: false,
        providers: const [],
        actions: [
          SignedOutAction((context) {
            Get.offAllNamed(Routes.login);
          }),
        ],
        avatarSize: 120,
        showDeleteConfirmationDialog: true,
        showUnlinkConfirmationDialog: false,
      ),
    );
  }
}
