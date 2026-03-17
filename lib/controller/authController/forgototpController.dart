// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:flutter_project/authpage/resetpassword.dart';
// import 'package:flutter_project/services/auth_service.dart';
//
//
// class Forgototpcontroller extends GetxController {
//   final String email;
//
//   Forgototpcontroller({required this.email});
//
//   final otpController = TextEditingController();
//
//   // Observable states
//   final seconds = 22.obs;
//   final canResend = false.obs;
//   final isLoading = false.obs;
//
//   Timer? _timer;
//
//   @override
//   void onInit() {
//     super.onInit();
//     startTimer();
//   }
//
//   @override
//   void onClose() {
//     _timer?.cancel();
//     otpController.dispose();
//     super.onClose();
//   }
//
//   void startTimer() {
//     canResend.value = false;
//     seconds.value = 22;
//
//     _timer?.cancel();
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (seconds.value > 0) {
//         seconds.value--;
//       } else {
//         canResend.value = true;
//         timer.cancel();
//       }
//     });
//   }
//
//   void resendOtp() {
//     if (!canResend.value) return;
//     startTimer();
//     // TODO: API call for resend OTP
//   }
//
//   Future<void> verifyOtp(BuildContext context) async {
//     final otp = otpController.text.trim();
//
//     if (otp.isEmpty || otp.length < 6) {
//       Get.snackbar(
//         "Error",
//         "Please enter a valid 6-digit OTP",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red.shade100,
//         colorText: Colors.red.shade900,
//       );
//       return;
//     }
//
//     isLoading.value = true;
//
//     try {
//       final result = await AuthService().verifyEmail(email: email, otp: otp);
//       print('email: $email');
//       print('otp: $otp');
//
//       if (result["status"] == 200) {
//         print(result['data']);
//
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => ResetPasswordPage(email: email),
//           ),
//         );
//
//       } else {
//         print(result['data']);
//         Get.snackbar(
//           "Error",
//           "Invalid OTP",
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red.shade100,
//           colorText: Colors.red.shade900,
//         );
//       }
//     } catch (e) {
//       Get.snackbar(
//         "Error",
//         "Something went wrong. Please try again.",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red.shade100,
//         colorText: Colors.red.shade900,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // void _showEmailVerifiedDropdown(BuildContext context) {
//   //   final overlay = Overlay.of(context);
//   //   OverlayEntry? overlayEntry;
//   //
//   //   overlayEntry = OverlayEntry(
//   //     builder: (context) => Positioned(
//   //       top: 300,
//   //       left: 16,
//   //       right: 16,
//   //       child: Material(
//   //         color: Colors.transparent,
//   //         child: Card(
//   //           shape: RoundedRectangleBorder(
//   //             borderRadius: BorderRadius.circular(20),
//   //           ),
//   //           color: Colors.white,
//   //           elevation: 8,
//   //           child: Padding(
//   //             padding: const EdgeInsets.all(20.0),
//   //             child: Column(
//   //               mainAxisSize: MainAxisSize.min,
//   //               children: [
//   //                 Image.asset(AppImages.Confirmimgae, height: 50.h, width: 50.w),
//   //                 SizedBox(height: 16.h),
//   //                 Text(
//   //                   "Email Verified!",
//   //                   style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
//   //                 ),
//   //                 SizedBox(height: 8.h),
//   //                 Text(email, style: TextStyle(fontSize: 16.sp)),
//   //                 const Text(
//   //                   "Your email address has been successfully verified",
//   //                   textAlign: TextAlign.center,
//   //                 ),
//   //                 SizedBox(height: 16.h),
//   //                 SizedBox(
//   //                   width: double.infinity,
//   //                   child: ElevatedButton(
//   //                     onPressed: () {
//   //                       overlayEntry?.remove();
//   //                       Navigator.push(
//   //                         context,
//   //                         MaterialPageRoute(
//   //                           builder: (_) => Resetpassword(email: email),
//   //                         ),
//   //                       );
//   //                       Navigator.push(context, MaterialPageRoute(builder: (context)=> Chatingpage()));
//   //                     },
//   //                     child: const Text("Continue"),
//   //                   ),
//   //                 ),
//   //               ],
//   //             ),
//   //           ),
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   //
//   //   overlay.insert(overlayEntry);
//   // }
// }