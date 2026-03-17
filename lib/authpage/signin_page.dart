import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/authController/signincontroller.dart';
import '../core/app_text.dart';
import '../images.dart';


class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignInController());

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

              SizedBox(height: 8.h),

              // Title
              AppText(
                data: "Sign In",
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),

              SizedBox(height: 20.h),

              // Username
              _inputField("Username", controller.usernameController),

              // Email
              _inputField("Email", controller.emailController),

              // Password
              Obx(() => _inputField(
                "Password",
                controller.passwordController,
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

              SizedBox(height: 8.h),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: controller.goToForgotPassword,
                  child: const AppText(
                    data: "Forgot password?",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),

              SizedBox(height: 12.h),

              // Sign In Button
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
                  onPressed: controller.isLoading.value ? null : controller.login,
                  child: controller.isLoading.value
                      ? const SizedBox(
                    height: 20, width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : const AppText(
                    data: "Sign In",
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                )),
              ),

              SizedBox(height: 20.h),

              // Divider
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: AppText(
                      data: "or",
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),

              SizedBox(height: 20.h),

              // Social Buttons
              Row(
                children: [
                  _socialButton(Icons.g_mobiledata),
                  SizedBox(width: 10.w),
                  _socialButton(Icons.apple),
                ],
              ),

              SizedBox(height: 16.h),

              // Sign Up redirect
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AppText(
                    data: "Don't have an account? ",
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                  GestureDetector(
                    onTap: controller.goToSignUp,
                    child: const AppText(
                      data: "Sign Up",
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField(
      String hint,
      TextEditingController controller, {
        bool isPassword = false,
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

  Widget _socialButton(IconData icon) {
    return Expanded(
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Icon(icon, size: 28, color: Colors.black87),
      ),
    );
  }
}