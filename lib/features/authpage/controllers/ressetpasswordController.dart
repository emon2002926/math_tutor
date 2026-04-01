import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/api_services.dart';
import '../../../core/util/app_navigation.dart';
import '../../../core/widgets/snakbar/custom_snackbar.dart';
import '../views/signin_page.dart';


class ResetPasswordController extends GetxController {
  final String resetToken;

  ResetPasswordController({required this.resetToken});

  final apiServices = Get.find<ApiServices>();

  final passwordController       = TextEditingController();
  final retypePasswordController = TextEditingController();

  final isLoading                = false.obs;
  final isPasswordVisible        = false.obs;
  final isRetypePasswordVisible  = false.obs;

  @override
  void onClose() {
    passwordController.dispose();
    retypePasswordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility()       => isPasswordVisible.value = !isPasswordVisible.value;
  void toggleRetypePasswordVisibility() => isRetypePasswordVisible.value = !isRetypePasswordVisible.value;

  void _showError(String message)   => CustomSnackBar.error(message);
  void _showSuccess(String message) => CustomSnackBar.success(message);

  String _parseError(HttpException e) {
    try {
      final decoded = jsonDecode(e.body ?? '{}') as Map<String, dynamic>;
      return decoded['detail'] ??
          decoded['message']   ??
          decoded['error']     ??
          'Something went wrong (${e.statusCode})';
    } catch (_) {
      return 'Something went wrong (${e.statusCode})';
    }
  }

  Future<void> resetPassword() async {
    final password       = passwordController.text.trim();
    final retypePassword = retypePasswordController.text.trim();

    if (password.isEmpty || retypePassword.isEmpty) {
      _showError('Please fill in all fields');
      return;
    }
    if (password.length < 6) {
      _showError('Password must be at least 6 characters');
      return;
    }
    if (password != retypePassword) {
      _showError('Passwords do not match');
      return;
    }

    isLoading.value = true;
    try {
      await apiServices.post(
        '/api/users/password-reset/confirm/',
        body: {
          'reset_token':      resetToken,
          'new_password':     password,
          'password_confirm': retypePassword,
        },
      );
      // No exception = 200 OK
      _showSuccess('Password reset successful');
      AppNavigation.pushAndClear(SignInPage());
    } on HttpException catch (e) {
      _showError(_parseError(e));
    } catch (e) {
      _showError('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }
}