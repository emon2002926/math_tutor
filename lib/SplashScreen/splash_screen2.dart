// splash_screen2.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/splashController/splash2Controller.dart';
import '../images.dart';


class SplashScreen2 extends StatelessWidget {
  const SplashScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Splash2Controller());

    return Scaffold(
      body: GestureDetector(
        onTap: controller.goToSplashScreen,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppImages.logo7,
                    height: 500,
                    width: 380,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Ask. Snap. Learn.✨",
                    style: TextStyle(
                      fontSize: 24,
                      color: Color(0xFF2B3A5D),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Type or snap a photo of your math problem and let your AI tutor do the rest",
                    style: TextStyle(
                      fontSize: 17,
                      color: Color(0xFF2B3A5D),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      onPressed: controller.goToLanguagePage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2B3A5D),
                        elevation: 0,
                        shadowColor: Colors.black.withOpacity(0.25),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ).copyWith(
                        shadowColor: WidgetStateProperty.all(
                          const Color(0x40000000),
                        ),
                        elevation: WidgetStateProperty.all(10),
                      ),
                      child: const Text(
                        "Continue",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Dot Indicator
                  Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(2, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: index == controller.activeIndex.value
                              ? Colors.black12
                              : Colors.green,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      );
                    }),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}