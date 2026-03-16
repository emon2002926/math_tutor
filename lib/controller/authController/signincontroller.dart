import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_project/authpage/singupOtppage.dart';
import 'package:flutter_project/authpage/signup_page.dart';
import 'package:flutter_project/authpage/forgotpassword_page.dart';
import 'package:flutter_project/services/auth_service.dart';

import '../../mainscreen/chat_page.dart';

class SigninController extends GetxController {
  // TextEditingControllers
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // Observable states
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // Password visibility toggle
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Navigate to Forgot Password
  void goToForgotPassword() {
    Get.to(() => ForgotpasswordPage());
  }

  // Navigate to Sign Up
  void goToSignUp() {
    Get.to(() => SignUpPage());
  }

  // Login Function
  Future<void> login() async {
    final email = emailController.text.trim();
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    // Basic validation
    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill in all fields",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
      return;
    }

    isLoading.value = true;

    try {
      final loginResult = await AuthService().loginUser(
        username: username,
        email: email,
        password: password,
      );


      print("asdf: $email");
      print("asdf: $username");
      print("asdf: $password");
      if (loginResult["success"]) {
        Get.snackbar(
          "Success",
          "Login Successful",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade900,
        );
        // Get.off(() => Otppage(email: email));
        Get.off(() => ChatPage());
      } else {
        Get.snackbar(
          "Error",
          loginResult["data"].toString(),
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