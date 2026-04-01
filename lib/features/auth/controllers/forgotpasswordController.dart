import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_project/features/auth/controllers/singupOtpController.dart';
import 'package:get/get.dart';
import '../../../core/services/api_services.dart';
import '../../../core/widgets/snakbar/custom_snackbar.dart';
import '../views/singup_otppage.dart';

class ForgotPasswordController extends GetxController {
  final ApiServices _api = Get.find<ApiServices>();

  final emailController = TextEditingController();
  final isLoading       = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

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

  Future<void> sendOtp() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      _showError('Please enter email');
      return;
    }

    isLoading.value = true;
    try {
      await _api.post(
        '/api/users/password-reset/',
        body: {"email": email},
      );

      _showSuccess('OTP sent to your email');
      Get.to(() => OtpPage(email: email, mode: OtpMode.forgotPassword));

    } on HttpException catch (e) {
      _showError(_parseError(e));
    } catch (e) {
      _showError('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }
}