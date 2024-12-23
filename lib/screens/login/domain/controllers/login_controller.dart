import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matka_game_app/navigation/routes.dart';
import 'package:matka_game_app/services/auth_service.dart';
import 'package:matka_game_app/services/user_service.dart';

class LoginController extends GetxController {
  final AuthService _authService;

  final RxBool isLoading = false.obs;

  LoginController(this._authService);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login() async {
    try {
      isLoading.value = true;
      final credentials = await _authService.loginWithEmailAndPassword(
        emailController.text,
        passwordController.text,
      );
      // Initiate user service to update user data.
      await Get.find<UserService>().init();
      isLoading.value = false;
      if (credentials != null) {
        Get.offAllNamed(Routes.home);
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        "Error",
        "Invalid credentials, please try again.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
