import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_project/authpage/singup_otppage.dart';
import 'package:flutter_project/authpage/signin_page.dart';
import 'package:flutter_project/services/auth_service.dart';
import '../../core/widgets/snakbar/custom_snackbar.dart';

class SignUpController extends GetxController {
  final usernameController        = TextEditingController();
  final emailController           = TextEditingController();
  final passwordController        = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading                  = false.obs;
  final isPasswordVisible          = false.obs;
  final isConfirmPasswordVisible   = false.obs;

  @override
  void onClose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility()        => isPasswordVisible.value = !isPasswordVisible.value;
  void toggleConfirmPasswordVisibility() => isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  void goToSignIn()                      => Get.to(() => SignInPage());

  void _showError(String message)   => CustomSnackBar.error(message);
  void _showSuccess(String message) => CustomSnackBar.success(message);

  // Parse field-level errors from API e.g. {"email": ["already exists"], "username": ["taken"]}
  String _parseError(dynamic data) {
    if (data is Map) {
      final messages = <String>[];
      data.forEach((key, value) {
        if (value is List) messages.add('$key: ${value.join(', ')}');
        else messages.add('$key: $value');
      });
      return messages.join('\n');
    }
    return data.toString();
  }

  Future<void> signUp() async {
    final username        = usernameController.text.trim();
    final email           = emailController.text.trim();
    final password        = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showError('Please fill in all fields');
      return;
    }

    if (password != confirmPassword) {
      _showError('Passwords do not match');
      return;
    }

    isLoading.value = true;
    try {
      final result = await AuthService.registerUser(
        email: email,
        username: username,
        password: password,
        confirmPassword: confirmPassword, // sent as 'password_confirm' inside AuthService
      );

      if (result['status'] == 201) {
        _showSuccess(result['data']['message'] ?? 'Registration successful');
        Get.to(() => OtpPage(email: email));
      } else {
        _showError(_parseError(result['data']));
      }
    } catch (e) {
      _showError('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }
}