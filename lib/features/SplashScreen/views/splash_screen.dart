import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash1Controller.dart';
import '../../../core/constants/images.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SplashController>();

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            AppImages.BackgroundImage,
            fit: BoxFit.cover,
          ),

          // Dark overlay
          Container(color: Colors.black.withOpacity(0.4)),

          // Center content
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Image.asset(
          //       AppImages.Centerlogo2,
          //       height: 600.h,
          //       width: 400.w,
          //       color: Colors.white,
          //     ),
          //     SizedBox(height: 40.h),
          //
          //     // Animated Dot Indicator
          //     Obx(() => Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: List.generate(2, (index) {
          //         final isActive = index == controller.activeIndex.value;
          //         return AnimatedContainer(
          //           duration: const Duration(milliseconds: 300),
          //           margin: EdgeInsets.symmetric(horizontal: 4.w),
          //           width: isActive ? 20.w : 10.w,   // active dot stretches wider
          //           height: 10.h,
          //           decoration: BoxDecoration(
          //             color: isActive ? Colors.green : Colors.white24,
          //             borderRadius: BorderRadius.circular(20),
          //           ),
          //         );
          //       }),
          //     )),
          //   ],
          // ),
        ],
      ),
    );
  }
}