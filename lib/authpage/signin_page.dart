import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/authController/signincontroller.dart';
import '../images.dart';


class SigninPage extends StatelessWidget {
  const SigninPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller initialize — GetX lazy load করবে
    final controller = Get.put(SigninController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                AppImages.Toplogo,
                height: 180.h,
                width: 140.w,
              ),

              SizedBox(height: 8.h),

              // Title
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Sign In",
                  style: GoogleFonts.montserrat(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(height: 12.h),

              _inputField("Username", controller.usernameController),
              _inputField("Email", controller.emailController),

              // Password field — visibility toggle এর জন্য Obx দরকার
              Obx(() => _inputField(
                "Password",
                controller.passwordController,
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

              // Forgot Password
              TextButton(
                onPressed: controller.goToForgotPassword,
                child: Text(
                  "Forgot password",
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: 15.h),

              // Sign In Button
              SizedBox(
                width: double.infinity,
                height: 40.h,
                child: Obx(() => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1F2A44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed:
                  controller.isLoading.value ? null : controller.login,
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
                    "Sign in",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                    ),
                  ),
                )),
              ),

              SizedBox(height: 10.h),

              // Divider
              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text("or"),
                  ),
                  Expanded(child: Divider()),
                ],
              ),

              SizedBox(height: 15.h),

              // Social Buttons
              Row(
                children: [
                  _socialButton(Icons.g_mobiledata),
                  SizedBox(width: 10.w),
                  _socialButton(Icons.apple),
                ],
              ),

              SizedBox(height: 10.h),

              // Sign Up redirect
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  TextButton(
                    onPressed: controller.goToSignUp,
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
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

  // Input Field Widget
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
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // Social Button
  Widget _socialButton(IconData icon) {
    return Expanded(
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Icon(icon, size: 28),
      ),
    );
  }
}