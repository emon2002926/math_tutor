import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/api_services.dart';
import '../../../core/widgets/snakbar/custom_snackbar.dart';
import '../views/signin_page.dart';
import '../views/singup_otppage.dart';

class SignUpController extends GetxController {
  final ApiServices _api = Get.find<ApiServices>();

  final usernameController        = TextEditingController();
  final emailController           = TextEditingController();
  final passwordController        = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading                = false.obs;
  final isPasswordVisible        = false.obs;
  final isConfirmPasswordVisible = false.obs;

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

  String _parseError(HttpException e) {
    try {
      final decoded = jsonDecode(e.body ?? '{}');
      if (decoded is Map) {
        final messages = <String>[];
        decoded.forEach((key, value) {
          if (value is List) messages.add('$key: ${value.join(', ')}');
          else messages.add('$key: $value');
        });
        return messages.join('\n');
      }
      return decoded['detail'] ?? decoded['message'] ?? decoded['error'] ??
          'Something went wrong (${e.statusCode})';
    } catch (_) {
      return 'Something went wrong (${e.statusCode})';
    }
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
      final data = await _api.post(
        '/api/users/register/',
        body: {
          "username": username,
          "email": email,
          "password": password,
          "password_confirm": confirmPassword,
        },
      );

      _showSuccess(data?['message'] ?? 'Registration successful');
      Get.to(() => OtpPage(email: email));

    } on HttpException catch (e) {
      _showError(_parseError(e));
    } catch (e) {
      _showError('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }
}