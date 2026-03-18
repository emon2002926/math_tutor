import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/authController/forgotpasswordController.dart';
import '../images.dart';


class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgotPasswordController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 22.h),

              // Logo
              Image.asset(AppImages.Toplogo, height: 200, width: 200),

              SizedBox(height: 20.h),

              // Title
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'forgot_password_title'.tr,
                  style: GoogleFonts.montserrat(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(height: 10.h),

              // Email Input
              _inputField('email'.tr, controller: controller.emailController),

              const Spacer(),

              // Send OTP Button
              SizedBox(
                width: double.infinity,
                child: Obx(() => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1F2A44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.sendOtp,
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
                    'send_otp'.tr,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                    ),
                  ),
                )),
              ),

              SizedBox(height: 16.h),
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
      }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: isPassword ? const Icon(Icons.visibility_off) : null,
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding:
        EdgeInsets.symmetric(horizontal: 20.h, vertical: 16.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}