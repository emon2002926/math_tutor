import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_project/authpage/signin_page.dart';
import 'package:get/get.dart';
import 'package:flutter_project/services/auth_service.dart';
import 'package:flutter_project/images.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../authpage/resetpassword.dart';
import '../../core/app_text.dart';
import '../../core/utils/api_service.dart';
import '../../core/utils/app_navigation.dart';
import '../../core/widgets/custom_snackbar.dart';
import '../../mainscreen/chat_page.dart';

enum OtpMode { register, forgotPassword }

class OtpController extends GetxController {
  final String email;
  final OtpMode mode;

  OtpController({required this.email, required this.mode});

  final apiServices = Get.find<ApiServices>();

  final otpController = TextEditingController();
  final seconds    = 30.obs;
  final canResend  = false.obs;
  final isLoading  = false.obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    otpController.dispose();
    super.onClose();
  }

  // ── Helpers ──────────────────────────────────────────
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

  // ── Timer ─────────────────────────────────────────────
  void startTimer() {
    canResend.value = false;
    seconds.value = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds.value > 0) {
        seconds.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  // ── Resend OTP ────────────────────────────────────────
  Future<void> resendOtp() async {
    if (!canResend.value) return;
    try {
      await apiServices.post(
        '/api/users/resend-otp/',
        body: {'email': email},
      );
      startTimer();
      _showSuccess('OTP resent to $email');
    } on HttpException catch (e) {
      _showError(_parseError(e));
    }
  }

  // ── Verify OTP ────────────────────────────────────────
  Future<void> verifyOtp(BuildContext context) async {
    final otp = otpController.text.trim();
    if (otp.isEmpty || otp.length < 6) {
      _showError('Please enter a valid 6-digit OTP');
      return;
    }

    isLoading.value = true;
    try {
      if (mode == OtpMode.register) {
        await _verifyRegisterOtp(context, otp);
      } else {
        await _verifyForgotPasswordOtp(otp);
      }
    } on HttpException catch (e) {
      _showError(_parseError(e));
    } catch (e) {
      _showError('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _verifyRegisterOtp(BuildContext context, String otp) async {
    await apiServices.post(
      '/api/users/verify-email/',
      body: {'email': email, 'otp': otp},
    );
    // If no exception thrown → 200 OK
    _showEmailVerifiedDialog(context);
  }

  Future<void> _verifyForgotPasswordOtp(String otp) async {
    final response = await apiServices.post(
      '/api/users/password-reset/verify/',
      body: {'email': email, 'otp': otp},
    ) as Map<String, dynamic>;

    final resetToken = response['reset_token'] as String?;
    if (resetToken != null) {
      _showSuccess('OTP verified');
      Get.off(() => ResetPasswordPage(resetToken: resetToken));
    } else {
      _showError('Reset token missing. Please try again.');
    }
  }

  // ── Email Verified Dialog ─────────────────────────────
  void _showEmailVerifiedDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(AppImages.Confirmimgae, height: 80, width: 80),
              const SizedBox(height: 16),
              const AppText(
                data: "Email Verified!",
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 8),
              AppText(data: email, fontSize: 14, color: Colors.grey),
              const SizedBox(height: 8),
              const AppText(
                data: "Your email has been successfully verified.",
                fontSize: 13,
                color: Colors.black54,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1F2A44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    AppNavigation.pushAndClear(SignInPage());
                  },
                  child: const AppText(
                    data: "Continue",
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}