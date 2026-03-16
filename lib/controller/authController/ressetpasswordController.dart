import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_project/mainscreen/chat_page.dart';
import 'package:flutter_project/services/auth_service.dart';

import '../../authpage/signin_page.dart';

class ResetPasswordController extends GetxController {
  final String email;

  ResetPasswordController({required this.email});

  final passwordController = TextEditingController();
  final retypePasswordController = TextEditingController();

  // Observable states
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final isRetypePasswordVisible = false.obs;

  @override
  void onClose() {
    passwordController.dispose();
    retypePasswordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleRetypePasswordVisibility() {
    isRetypePasswordVisible.value = !isRetypePasswordVisible.value;
  }

  Future<void> resetPassword() async {
    final password = passwordController.text;
    final retypePassword = retypePasswordController.text;

    // Validation
    if (password.isEmpty || retypePassword.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill in all fields",
      );
      return;
    }

    if (password.length < 6) {
      Get.snackbar(
        "Error",
        "Password must be at least 6 characters",
      );
      return;
    }

    if (password != retypePassword) {
      Get.snackbar(
        "Error",
        "Passwords do not match",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
      return;
    }

    isLoading.value = true;

  //   try {
  //     final result = await AuthService().resetPassword(
  //       new_password: passwordController.text,
  //       confirm_password: retypePasswordController.text,
  //     );
  //
  //     if (result["status"] == 200) {
  //       Get.snackbar(
  //         "Success",
  //         "Password reset successful",
  //         snackPosition: SnackPosition.BOTTOM,
  //         backgroundColor: Colors.green.shade100,
  //         colorText: Colors.green.shade900,
  //       );
  //       Get.offAll(() => SigninPage());
  //     } else {
  //       Get.snackbar(
  //         "Error",
  //         result["data"] ?? "Reset failed",
  //         snackPosition: SnackPosition.BOTTOM,
  //         backgroundColor: Colors.red.shade100,
  //         colorText: Colors.red.shade900,
  //       );
  //     }
  //   } catch (e) {
  //     Get.snackbar(
  //       "Error",
  //       "Something went wrong. Please try again.",
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: Colors.red.shade100,
  //       colorText: Colors.red.shade900,
  //     );
  //   } finally {
  //     isLoading.value = false;
  //   }
   }
}