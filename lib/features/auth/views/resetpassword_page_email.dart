import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/widgets/text/app_text.dart';
import '../../../core/constants/images.dart';
import '../controllers/ressetpasswordController.dart';



class ResetPasswordPage extends StatelessWidget {
  final String resetToken;

  const ResetPasswordPage({super.key, required this.resetToken});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ResetPasswordController(resetToken: resetToken));

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
                data: 'reset_password'.tr,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),

              SizedBox(height: 8.h),

              AppText(
                data: 'reset_password_subtitle'.tr,
                fontSize: 13,
                color: Colors.black54,
              ),

              SizedBox(height: 24.h),

              // New Password
              Obx(() => _inputField(
                'new_password'.tr,
                controller: controller.passwordController,
                isPassword: !controller.isPasswordVisible.value,
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isPasswordVisible.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: controller.togglePasswordVisibility,
                ),
              )),

              // Confirm Password
              Obx(() => _inputField(
                'confirm_password'.tr,
                controller: controller.retypePasswordController,
                isPassword: !controller.isRetypePasswordVisible.value,
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isRetypePasswordVisible.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: controller.toggleRetypePasswordVisibility,
                ),
              )),

              SizedBox(height: 32.h),

              // Confirm Button
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
                      : controller.resetPassword,
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
                    data: 'confirm'.tr,
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

  Widget _inputField(
      String hint, {
        bool isPassword = false,
        TextEditingController? controller,
        Widget? suffixIcon,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
            borderSide: const BorderSide(color: Color(0xFF1F2A44), width: 1.5),
          ),
        ),
      ),
    );
  }
}