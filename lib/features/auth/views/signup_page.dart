import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/util/screen_size.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/text/app_text.dart';
import '../../../core/constants/images.dart';
import '../../../core/widgets/text/text_field/AppTextFiled.dart';
import '../controllers/singupController.dart';


class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());
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

                    // ── Logo ──────────────────────────────────────────────
                    Center(
                      child: Image.asset(
                        AppImages.Toplogo,
                        height: context.h(isTablet ? 120 : 180),
                        width: context.w(isTablet ? 100 : 140),
                        fit: BoxFit.contain,
                      ),
                    ),

                    SizedBox(height: context.h(isTablet ? 24 : 8)),

                    // ── Title ─────────────────────────────────────────────
                    AppText(
                      data: 'sign_up'.tr,
                      // fontSize: isTablet ? 22 : 28,
                      fontSize: isTablet ? 22 : 28,
                      fontWeight: FontWeight.w900,
                      googleFontFamily: GoogleFonts.montserrat,
                      // fontWeight: FontWeight.bold,
                      color: const Color(0xFF1F2A44),
                    ),

                    SizedBox(height: context.h(20)),

                    // ── Username ──────────────────────────────────────────
                    AppTextField(
                      hintText: 'username'.tr,
                      controller: controller.usernameController,
                      focusedErrorBorderColor: const Color(0xFF1F2A44),
                      prefixIcon: Icons.person_outline,
                    ),

                    SizedBox(height: context.h(4)),

                    // ── Email ─────────────────────────────────────────────
                    AppTextField(
                      hintText: 'email'.tr,
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      focusedErrorBorderColor: const Color(0xFF1F2A44),
                      prefixIcon: Icons.email_outlined,
                    ),

                    SizedBox(height: context.h(4)),

                    // ── Password ──────────────────────────────────────────
                    Obx(() => AppTextField(
                      hintText: 'password'.tr,
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
                      controller: controller.confirmPasswordController,
                      obscureText:
                      !controller.isConfirmPasswordVisible.value,
                      focusedErrorBorderColor: const Color(0xFF1F2A44),
                      prefixIcon: Icons.lock_outline,
                      suffixWidget: IconButton(
                        icon: Icon(
                          controller.isConfirmPasswordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black54,
                          size: context.sp(20),
                        ),
                        onPressed:
                        controller.toggleConfirmPasswordVisibility,
                      ),
                    )),

                    SizedBox(height: context.h(12)),

                    // ── Sign Up Button ────────────────────────────────────
                    Obx(() => AppButton(
                      buttonText: 'sign_up'.tr,
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.signUp,
                      isLoading: controller.isLoading.value,
                      fillColor: const Color(0xFF1F2A44),
                      borderRadius: 15,
                      fontSize: 16,
                      buttonHeight: 50,
                      fontWeight: FontWeight.w600,
                    )),

                    SizedBox(height: context.h(20)),

                    // ── Divider ───────────────────────────────────────────
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: context.w(12)),
                          child: AppText(
                            data: 'or'.tr,
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),

                    SizedBox(height: context.h(20)),

                    // ── Social Buttons ────────────────────────────────────
                    Row(
                      children: [
                        _socialButton(context, Icons.g_mobiledata),
                        SizedBox(width: context.w(10)),
                        _socialButton(context, Icons.apple),
                      ],
                    ),

                    SizedBox(height: context.h(16)),

                    // ── Sign In redirect ──────────────────────────────────
                    Center(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          AppText(
                            data: 'already_have_account'.tr,
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                          GestureDetector(
                            onTap: controller.goToSignIn,
                            child: AppText(
                              data: 'sign_in'.tr,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
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

  Widget _socialButton(BuildContext context, IconData icon) {
    return Expanded(
      child: Container(
        height: context.h(50),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(context.w(30)),
        ),
        child: Icon(icon, size: context.sp(28), color: Colors.black87),
      ),
    );
  }
}