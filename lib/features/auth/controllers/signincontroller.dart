import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/api_services.dart';
import '../../../core/util/storage_service.dart';
import '../../../core/widgets/snakbar/custom_snackbar.dart';
import '../../chat/views/chat_page.dart';
import '../views/forgotpassword_page.dart';
import '../views/signup_page.dart';

class SignInController extends GetxController {
  final ApiServices _api = Get.find<ApiServices>();

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

  String _parseError(HttpException e) {
    try {
      final decoded = jsonDecode(e.body ?? '{}') as Map<String, dynamic>;
      return decoded['detail'] ?? decoded['message'] ?? decoded['error'] ??
          'Something went wrong (${e.statusCode})';
    } catch (_) {
      return 'Something went wrong (${e.statusCode})';
    }
  }

  Future<void> login() async {
    final email    = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError('Please fill in all fields');
      return;
    }

    isLoading.value = true;
    try {
      final data = await _api.post(
        '/api/users/login/',
        body: {"email": email, "password": password},
      );

      final accessToken = data?["tokens"]?["access"];
      if (accessToken != null) {
        StorageService.saveToken(accessToken);
      }

      _showSuccess('Login Successful');
      Get.offAll(() => ChatPage());

    } on HttpException catch (e) {
      _showError(_parseError(e));
    } catch (e) {
      _showError('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }
}