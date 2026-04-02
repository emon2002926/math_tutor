import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/images.dart';
import '../../../core/util/screen_size.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/text/app_text.dart';
import '../../../core/widgets/text/text_field/AppTextFiled.dart';
import '../controllers/forgotpasswordController.dart';


class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgotPasswordController());
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

                    SizedBox(height: context.h(22)),

                    // ── Logo ──────────────────────────────────────────────
                    Center(
                      child: Image.asset(
                        AppImages.Toplogo,
                        height: context.h(isTablet ? 130 : 180),
                        width: context.w(isTablet ? 110 : 150),
                        fit: BoxFit.contain,
                      ),
                    ),

                    SizedBox(height: context.h(24)),

                    // ── Title ─────────────────────────────────────────────
                    AppText(
                      data: 'forgot_password_title'.tr,
                      fontSize: isTablet ? 22 : 26,
                      fontWeight: FontWeight.w900,
                      googleFontFamily: GoogleFonts.montserrat,
                      color: const Color(0xFF1F2A44),
                    ),

                    SizedBox(height: context.h(8)),

                    // ── Subtitle ──────────────────────────────────────────
                    AppText(
                      data: 'forgot_password_subtitle'.tr,
                      fontSize: 14,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w400,
                      googleFontFamily: GoogleFonts.roboto,
                    ),

                    SizedBox(height: context.h(24)),

                    // ── Email Input ───────────────────────────────────────
                    AppTextField(
                      hintText: 'email'.tr,
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      focusedErrorBorderColor: const Color(0xFF1F2A44),
                      prefixIcon: Icons.email_outlined,
                    ),

                    SizedBox(height: context.h(32)),

                    // ── Send OTP Button ───────────────────────────────────
                    Obx(() => AppButton(
                      buttonText: 'send_otp'.tr,
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.sendOtp,
                      isLoading: controller.isLoading.value,
                      fillColor: const Color(0xFF1F2A44),
                      borderRadius: 15,
                      fontSize: 16,
                      buttonHeight: 50,
                      fontWeight: FontWeight.w600,
                    )),

                    SizedBox(height: context.h(16)),

                    // ── Back to Sign In ───────────────────────────────────
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