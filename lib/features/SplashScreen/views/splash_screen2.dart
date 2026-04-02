// splash_screen2.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/util/screen_size.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/text/app_text.dart';
import '../controllers/splash2Controller.dart';
import '../../../core/constants/images.dart';


class SplashScreen2 extends StatelessWidget {
  const SplashScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Splash2Controller());
    final isTablet = context.isTabletDevice;

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: controller.goToSplashScreen,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: context.pagePadding,
                vertical: context.h(16),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    // ── Logo ────────────────────────────────────────────
                    Image.asset(
                      AppImages.logo7,
                      height: context.h(isTablet ? 320 : 460),
                      width: context.w(isTablet ? 300 : 360),
                      fit: BoxFit.contain,
                    ),

                    SizedBox(height: context.h(16)),

                    // ── Tagline ──────────────────────────────────────────
                    AppText(
                      data: 'splash_tagline'.tr,
                      fontSize: isTablet ? 20 : 22,
                      color: const Color(0xFF2B3A5D),
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w700,
                    ),

                    SizedBox(height: context.h(10)),

                    // ── Description ──────────────────────────────────────
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: context.w(8)),
                      child: AppText(
                        data: 'splash_description'.tr,
                        fontSize: isTablet ? 14 : 15,
                        color: const Color(0xFF2B3A5D),
                        textAlign: TextAlign.center,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    SizedBox(height: context.h(32)),

                    // ── Continue Button ───────────────────────────────────
                    AppButton(
                      buttonText: 'continue'.tr,
                      onPressed: controller.goToLanguagePage,
                      fillColor: const Color(0xFF2B3A5D),
                      buttonWidth: isTablet ? context.w(260) : context.w(280),
                      buttonHeight: 50,
                      borderRadius: 16,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),

                    SizedBox(height: context.h(20)),

                    // ── Dot Indicator ─────────────────────────────────────
                    Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(2, (index) {
                        final isActive =
                            index == controller.activeIndex.value;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          margin: EdgeInsets.symmetric(
                              horizontal: context.w(4)),
                          width: isActive ? context.w(20) : context.w(8),
                          height: context.w(8),
                          decoration: BoxDecoration(
                            color: isActive
                                ? const Color(0xFF2B3A5D)
                                : const Color(0xFF2B3A5D).withOpacity(0.25),
                            borderRadius:
                            BorderRadius.circular(context.w(20)),
                          ),
                        );
                      }),
                    )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}