import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/util/screen_size.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/text/app_text.dart';
import '../../../core/constants/images.dart';
import '../../../core/widgets/text/text_field/AppTextFiled.dart';
import '../controllers/signincontroller.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignInController());
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
                      ),
                    ),

                    SizedBox(height: context.h(isTablet ? 24 : 8)),

                    // ── Title ─────────────────────────────────────────────
                    AppText(
                      data: 'sign_in'.tr,
                      fontSize: isTablet ? 22 : 28,
                      fontWeight: FontWeight.w900,
                      googleFontFamily: GoogleFonts.montserrat,
                    ),

                    SizedBox(height: context.h(20)),

                    // ── Email ─────────────────────────────────────────────
                    AppTextField(
                      hintText: 'email'.tr,
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      focusedErrorBorderColor: const Color(0xFF1F2A44),
                    ),

                    SizedBox(height: context.h(4)),

                    // ── Password ──────────────────────────────────────────
                    Obx(() => AppTextField(
                      hintText: 'password'.tr,
                      controller: controller.passwordController,
                      obscureText: !controller.isPasswordVisible.value,
                      focusedErrorBorderColor: const Color(0xFF1F2A44),
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

                    // ── Forgot Password ───────────────────────────────────
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: controller.goToForgotPassword,
                        child: AppText(
                          data: 'forgot_password'.tr,
                          fontSize: context.sp(14),
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    SizedBox(height: context.h(12)),

                    // ── Sign In Button ────────────────────────────────────

                    Obx(() => AppButton(
                      buttonText: 'sign_in'.tr,
                      onPressed: controller.isLoading.value ? null : controller.login,
                      isLoading: controller.isLoading.value,
                      fillColor: const Color(0xFF1F2A44),
                      borderRadius: 15,
                      fontSize: 16,
                      buttonHeight: 50,
                      fontWeight: FontWeight.w600,
                    )),
                    // Obx(() => SizedBox(
                    //   width: double.infinity,
                    //   height: context.h(50),
                    //   child: ElevatedButton(
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: const Color(0xFF1F2A44),
                    //       elevation: 0,
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(context.w(15)),
                    //       ),
                    //     ),
                    //     onPressed: controller.isLoading.value
                    //         ? null
                    //         : controller.login,
                    //     child: controller.isLoading.value
                    //         ? SizedBox(
                    //       height: context.h(20),
                    //       width: context.w(20),
                    //       child: const CircularProgressIndicator(
                    //         color: Colors.white,
                    //         strokeWidth: 2,
                    //       ),
                    //     )
                    //         : AppText(
                    //       data: 'sign_in'.tr,
                    //       color: Colors.white,
                    //       fontSize: context.sp(16),
                    //       fontWeight: FontWeight.w600,
                    //     ),
                    //   ),
                    // )),

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
                            fontSize: context.sp(13),
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
                        _socialButton(context, null,"assets/images/google_logo.png"),
                        SizedBox(width: context.w(10)),
                        _socialButton(context, Icons.apple,null),
                      ],
                    ),

                    SizedBox(height: context.h(16)),

                    // ── Sign Up redirect ──────────────────────────────────
                    Center(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          AppText(
                            data: 'dont_have_account'.tr,
                            fontSize: context.sp(14),
                            color: Colors.black54,
                          ),
                          GestureDetector(
                            onTap: controller.goToSignUp,
                            child: AppText(
                              data: ' ${'sign_up'.tr}',
                              fontSize: context.sp(14),
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _socialButton(BuildContext context, IconData? icon,String? imageAssets) {
    return Expanded(
      child: Container(
        height: context.h(50),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(context.w(30)),
        ),
        child: icon != null?Icon(icon, size: context.sp(32), color: Colors.black87)
            :Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset(imageAssets!,height: context.sp(28),width: context.sp(28),),
            ),
      ),
    );
  }
}