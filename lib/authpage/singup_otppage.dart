import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/authController/singupOtpController.dart';
import '../core/app_text.dart';
import '../images.dart';


class OtpPage extends StatelessWidget {
  final String email;
  final OtpMode mode;

  const OtpPage({
    super.key,
    required this.email,
    this.mode = OtpMode.register,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OtpController(email: email, mode: mode));

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              Center(
                child: Image.asset(
                  AppImages.Toplogo,
                  height: 180.h,
                  width: 140.w,
                ),
              ),

              SizedBox(height: 20.h),

              // Title
              AppText(
                data: 'enter_otp'.tr,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),

              SizedBox(height: 8.h),

              // Subtitle — email is dynamic, use trArgs
              AppText(
                data: 'otp_sent_to'.trArgs([email]),
                fontSize: 13,
                color: Colors.black54,
              ),

              SizedBox(height: 24.h),

              // OTP Input
              TextField(
                controller: controller.otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.start,
                style: const TextStyle(fontSize: 20, letterSpacing: 4),
                decoration: InputDecoration(
                  hintText: 'otp_hint'.tr,
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 14,
                    letterSpacing: 0,
                  ),
                  counterText: "",
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                        color: Color(0xFF1F2A44), width: 1.5),
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              // Timer & Resend
              Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    data: controller.canResend.value
                        ? 'otp_not_received'.tr
                        : 'otp_resend_in'.trArgs([
                      '0:${controller.seconds.value.toString().padLeft(2, '0')}'
                    ]),
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                  if (controller.canResend.value)
                    GestureDetector(
                      onTap: controller.resendOtp,
                      child: AppText(
                        data: 'resend'.tr,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1F2A44),
                      ),
                    ),
                ],
              )),

              SizedBox(height: 32.h),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: Obx(() => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1F2A44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.verifyOtp(context),
                  child: controller.isLoading.value
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : AppText(
                    data: 'submit'.tr,
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}