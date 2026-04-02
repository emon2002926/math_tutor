import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/util/screen_size.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/text/app_text.dart';
import '../../../core/constants/images.dart';
import '../../../core/widgets/text/text_field/AppTextFiled.dart';
import '../controllers/singupOtpController.dart';


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
    final isTablet = context.isTabletDevice;

    return Scaffold(
      backgroundColor: isTablet ? const Color(0xFFF0F2F5) : Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: context.pagePadding,
              vertical: context.h(16),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Container(
                padding: isTablet
                    ? EdgeInsets.symmetric(
                  horizontal: context.w(40),
                  vertical: context.h(48),
                )
                    : EdgeInsets.symmetric(
                  horizontal: context.w(4),
                  vertical: context.h(8),
                ),
                decoration: isTablet
                    ? BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(context.w(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 32,
                      offset: const Offset(0, 8),
                    ),
                  ],
                )
                    : null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    SizedBox(height: context.h(isTablet ? 8 : 22)),

                    // ── Logo ──────────────────────────────────────────────
                    Center(
                      child: Image.asset(
                        AppImages.Toplogo,
                        height: context.h(isTablet ? 120 : 180),
                        width: context.w(isTablet ? 100 : 140),
                        fit: BoxFit.contain,
                      ),
                    ),

                    SizedBox(height: context.h(24)),

                    // ── Title ─────────────────────────────────────────────
                    AppText(
                      data: 'enter_otp'.tr,
                      fontSize: isTablet ? 22 : 26,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1F2A44),
                    ),

                    SizedBox(height: context.h(8)),

                    // ── Subtitle ──────────────────────────────────────────
                    AppText(
                      data: 'otp_sent_to'.trArgs([email]),
                      fontSize: 13,
                      color: Colors.black54,
                      maxLines: 2,
                    ),

                    SizedBox(height: context.h(24)),

                    // ── OTP Input ─────────────────────────────────────────
                    AppTextField(
                      hintText: 'otp_hint'.tr,
                      controller: controller.otpController,
                      keyboardType: TextInputType.number,
                      focusedErrorBorderColor: const Color(0xFF1F2A44),
                    ),

                    SizedBox(height: context.h(12)),

                    // ── Timer & Resend ────────────────────────────────────
                    Obx(() => Center(
                      child: Wrap(
                        alignment: WrapAlignment.center,
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
                      ),
                    )),

                    SizedBox(height: context.h(32)),

                    // ── Submit Button ─────────────────────────────────────
                    Obx(() => AppButton(
                      buttonText: 'submit'.tr,
                      onPressed: controller.isLoading.value
                          ? null
                          : () => controller.verifyOtp(context),
                      isLoading: controller.isLoading.value,
                      fillColor: const Color(0xFF1F2A44),
                      borderRadius: 15,
                      fontSize: 16,
                      buttonHeight: 50,
                      fontWeight: FontWeight.w600,
                    )),

                    SizedBox(height: context.h(16)),

                    // ── Back ──────────────────────────────────────────────
                    Center(
                      child: TextButton(
                        onPressed: () => Get.back(),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            AppText(
                              data: 'back_to'.tr,
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                            AppText(
                              data: ' ${'sign_in'.tr}',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: context.h(16)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}