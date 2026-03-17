// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import '../controller/authController/forgototpController.dart';
// import '../images.dart';
//
//
// class Forgototppage extends StatelessWidget {
//   final String email;
//
//   const Forgototppage({super.key, required this.email});
//
//   @override
//   Widget build(BuildContext context) {
//     // email pass করে controller initialize
//     final controller = Get.put(Forgototpcontroller(email: email));
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SizedBox(height: 22.h),
//
//                 // Logo
//                 Image.asset(
//                   AppImages.Toplogo,
//                   height: 200.h,
//                   width: 200.w,
//                 ),
//
//                 SizedBox(height: 20.h),
//
//                 // Title
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                     "Enter OTP",
//                     style: GoogleFonts.montserrat(
//                       fontSize: 28.sp,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//
//                 SizedBox(height: 10.h),
//
//                 // OTP Input Field
//                 _otpSingleField(controller),
//
//                 SizedBox(height: 180.h),
//
//                 // Timer & Resend section
//                 Column(
//                   children: [
//                     const Text(
//                       "We sent a verification code to your email. Please check.",
//                       textAlign: TextAlign.center,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Text("If not, resend in "),
//
//                         // Timer — Obx দিয়ে reactive
//                         Obx(() => Text(
//                           "0:${controller.seconds.value.toString().padLeft(2, '0')} ",
//                           style: const TextStyle(fontWeight: FontWeight.bold),
//                         )),
//
//                         // Resend button — canResend অনুযায়ী enable/disable
//                         Obx(() => TextButton(
//                           onPressed: controller.canResend.value
//                               ? controller.resendOtp
//                               : null,
//                           child: const Text("Resend"),
//                         )),
//                       ],
//                     ),
//                   ],
//                 ),
//
//                 // Confirm Button
//                 SizedBox(
//                   width: double.infinity,
//                   child: Obx(() => ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF1F2A44),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                     ),
//                     onPressed: controller.isLoading.value
//                         ? null
//                         : () => controller.verifyOtp(context),
//                     child: controller.isLoading.value
//                         ? const SizedBox(
//                       height: 20,
//                       width: 20,
//                       child: CircularProgressIndicator(
//                         color: Colors.white,
//                         strokeWidth: 2,
//                       ),
//                     )
//                         : Text(
//                       "Submit",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16.sp,
//                       ),
//                     ),
//                   )),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // OTP Input Field Widget
//   Widget _otpSingleField(Forgototpcontroller controller) {
//     return TextField(
//       controller: controller.otpController,
//       keyboardType: TextInputType.number,
//       maxLength: 6,
//       textAlign: TextAlign.start,
//       style: TextStyle(fontSize: 20.sp),
//       decoration: InputDecoration(
//         hintText: "Enter 6 digit OTP",
//         counterText: "",
//         filled: true,
//         fillColor: Colors.grey.shade100,
//         contentPadding: EdgeInsets.symmetric(horizontal: 18.h, vertical: 12.w),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(30),
//           borderSide: BorderSide.none,
//         ),
//       ),
//     );
//   }
// }