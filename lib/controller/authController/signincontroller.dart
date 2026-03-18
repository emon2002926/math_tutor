import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_project/authpage/signup_page.dart';
import 'package:flutter_project/authpage/forgotpassword_page.dart';
import 'package:flutter_project/services/auth_service.dart';

import '../../core/widgets/custom_snackbar.dart';
import '../../mainscreen/chat_page.dart';

class SignInController extends GetxController {
  final emailController    = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading         = false.obs;
  final isPasswordVisible = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() =>
      isPasswordVisible.value = !isPasswordVisible.value;

  void goToForgotPassword() => Get.to(() => ForgotPasswordPage());
  void goToSignUp()         => Get.to(() => SignUpPage());

  void _showError(String message)   => CustomSnackBar.error(message);


  void _showSuccess(String message) => CustomSnackBar.success(message);


  Future<void> login() async {
    final email    = emailController.text.trim();
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      _showError('Please fill in all fields');
      return;
    }

    isLoading.value = true;
    try {
      final loginResult = await AuthService().loginUser(
        username: username,
        email: email,
        password: password,
      );

      if (loginResult['success']) {
        _showSuccess('Login Successful');
        Get.offAll(() => ChatPage());
      } else {
        _showError(loginResult['data'].toString());
      }
    } catch (e) {
      _showError('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }
}