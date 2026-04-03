import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/util/screen_size.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/text/app_text.dart';
import '../../../core/constants/images.dart';
import '../../../core/widgets/text/text_field/AppTextFiled.dart';
import '../controllers/ressetpasswordController.dart';



class ResetPasswordPage extends StatelessWidget {
  final String resetToken;
  const ResetPasswordPage({super.key, required this.resetToken});

  @override
  Widget build(BuildContext context) {
    final controller =
    Get.put(ResetPasswordController(resetToken: resetToken));
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

                    SizedBox(height: context.h(isTablet ? 24 : 20)),

                    // ── Title ─────────────────────────────────────────────
                    AppText(
                      data: 'reset_password'.tr,
                      fontSize: isTablet ? 22 : 28,
                      fontWeight: FontWeight.w900,
                      googleFontFamily: GoogleFonts.montserrat,
                      color: const Color(0xFF1F2A44),
                    ),

                    SizedBox(height: context.h(8)),

                    // ── Subtitle ──────────────────────────────────────────
                    AppText(
                      data: 'reset_password_subtitle'.tr,
                      fontSize: 13,
                      color: Colors.black54,
                      maxLines: 3,
                    ),

                    SizedBox(height: context.h(24)),

                    // ── New Password ──────────────────────────────────────
                    Obx(() => AppTextField(
                      hintText: 'new_password'.tr,
                      controller: controller.passwordController,
                      obscureText: !controller.isPasswordVisible.value,
                      focusedErrorBorderColor: const Color(0xFF1F2A44),
                      prefixIcon: Icons.lock_outline,
                      suffixWidget: IconButton(
                        icon: Icon(
                          controller.isPasswordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black54,
                          size: context.sp(20),
                        ),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                    )),

                    SizedBox(height: context.h(4)),

                    // ── Confirm Password ──────────────────────────────────
                    Obx(() => AppTextField(
                      hintText: 'confirm_password'.tr,
                      controller: controller.retypePasswordController,
                      obscureText:
                      !controller.isRetypePasswordVisible.value,
                      focusedErrorBorderColor: const Color(0xFF1F2A44),
                      prefixIcon: Icons.lock_outline,
                      suffixWidget: IconButton(
                        icon: Icon(
                          controller.isRetypePasswordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black54,
                          size: context.sp(20),
                        ),
                        onPressed:
                        controller.toggleRetypePasswordVisibility,
                      ),
                    )),

                    SizedBox(height: context.h(32)),

                    // ── Confirm Button ────────────────────────────────────
                    Obx(() => AppButton(
                      buttonText: 'confirm'.tr,
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.resetPassword,
                      isLoading: controller.isLoading.value,
                      fillColor: const Color(0xFF1F2A44),
                      borderRadius: 15,
                      buttonHeight: 50,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    )),

                    SizedBox(height: context.h(16)),


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