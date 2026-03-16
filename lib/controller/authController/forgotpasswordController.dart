import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_project/authpage/singupOtppage.dart';
import 'package:flutter_project/services/auth_service.dart';

import '../../authpage/forgotOtppage.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();

  // Observable states
  final isLoading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  Future<void> sendOtp() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter email",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
      return;
    }

    isLoading.value = true;

    try {
      // API call for sending OTP
      final result = await AuthService().forgotPassword(email: email);

      if (result["status"] == 200) {
        Get.snackbar(
          "Success",
          "OTP sent to your email",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade900,
        );
        Get.to(() => Forgototppage(email: email));
      } else {
        Get.snackbar(
          "Error",
          result["data"].toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    } finally {
      isLoading.value = false;
    }
  }
}