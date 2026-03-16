import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/authController/ressetpasswordController.dart';
import '../images.dart';


class Resetpassword extends StatelessWidget {
  final String email;

  const Resetpassword({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ResetPasswordController(email: email));

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 22.h),

                // Logo
                Image.asset(
                  AppImages.Toplogo,
                  height: 200.h,
                  width: 150.w,
                ),

                SizedBox(height: 25.h),

                // Title
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Reset Your Password",
                    style: GoogleFonts.montserrat(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(height: 20.sp),

                // Password field
                Obx(() => _inputField(
                  "Password",
                  controller: controller.passwordController,
                  isPassword: !controller.isPasswordVisible.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: controller.togglePasswordVisibility,
                  ),
                )),

                SizedBox(height: 10.h),

                // Retype Password field
                Obx(() => _inputField(
                  "Re-type your password",
                  controller: controller.retypePasswordController,
                  isPassword: !controller.isRetypePasswordVisible.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isRetypePasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: controller.toggleRetypePasswordVisibility,
                  ),
                )),

                SizedBox(height: 180.h),

                // Confirm Button
                SizedBox(
                  width: double.infinity,
                  height: 35.h,
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
                        : Text(
                      "Confirm",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                      ),
                    ),
                  )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Input Field Widget
  Widget _inputField(
      String hint, {
        bool isPassword = false,
        TextEditingController? controller,
        Widget? suffixIcon,
      }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 16.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}