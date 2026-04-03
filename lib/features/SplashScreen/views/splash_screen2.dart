// splash_screen2.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
      backgroundColor: isTablet ? const Color(0xFFF0F2F5) : Colors.white,
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
                constraints: const BoxConstraints(maxWidth: 480),
                child: Container(
                  padding: isTablet
                      ? EdgeInsets.symmetric(
                    horizontal: context.w(40),
                    vertical: context.h(48),
                  )
                      : EdgeInsets.symmetric(
                    horizontal: context.w(4),
                    vertical: context.h(8),
                  ),
                  decoration: isTablet
                      ? BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(context.w(24)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 32,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  )
                      : null,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      // ── Logo ──────────────────────────────────────────
                      Image.asset(
                        AppImages.logo7,
                        height: context.h(isTablet ? 280 : 460),
                        width: context.w(isTablet ? 260 : 360),
                        fit: BoxFit.contain,
                      ),

                      SizedBox(height: context.h(isTablet ? 24 : 16)),

                      // ── Tagline ───────────────────────────────────────
                      AppText(
                        data: 'splash_tagline'.tr,
                        fontSize: isTablet ? 22 : 26,
                        fontWeight: FontWeight.w900,
                        googleFontFamily: GoogleFonts.montserrat,                        color: const Color(0xFF2B3A5D),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: context.h(10)),

                      // ── Description ───────────────────────────────────
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: context.w(8)),
                        child: AppText(
                          data: 'splash_description'.tr,
                          fontSize: isTablet ? 14 : 15,
                          color: const Color(0xFF2B3A5D).withOpacity(0.7),
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w400,
                          maxLines: 4,
                        ),
                      ),

                      SizedBox(height: context.h(32)),

                      // ── Continue Button ───────────────────────────────
                      AppButton(
                        buttonText: 'continue'.tr,
                        onPressed: controller.goToLanguagePage,
                        fillColor: const Color(0xFF2B3A5D),
                        buttonWidth: context.w(isTablet ? 260 : 280),
                        buttonHeight: 50,
                        borderRadius: 15,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),

                      SizedBox(height: context.h(20)),

                      // ── Dot Indicator ─────────────────────────────────
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
                            width: isActive
                                ? context.w(20)
                                : context.w(8),
                            height: context.w(8),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? const Color(0xFF2B3A5D)
                                  : const Color(0xFF2B3A5D)
                                  .withOpacity(0.25),
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
      ),
    );
  }
}
// ── Phone Layout ───────────────────────────────────────────────────────────
class _PhoneLayout extends StatelessWidget {
  final Splash2Controller controller;
  const _PhoneLayout({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: context.pagePadding,
        vertical: context.h(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            AppImages.logo7,
            height: context.h(460),
            width: context.w(360),
            fit: BoxFit.contain,
          ),
          SizedBox(height: context.h(16)),
          _SplashTexts(controller: controller, isTablet: false),
        ],
      ),
    );
  }
}

// ── Tablet Layout ──────────────────────────────────────────────────────────
class _TabletLayout extends StatelessWidget {
  final Splash2Controller controller;
  const _TabletLayout({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.w(48),
        vertical: context.h(32),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          // ── Left: Logo ─────────────────────────────────────────────
          Expanded(
            child: Image.asset(
              AppImages.logo7,
              height: context.h(380),
              fit: BoxFit.contain,
            ),
          ),

          SizedBox(width: context.w(48)),

          // ── Right: Text + Button ───────────────────────────────────
          Expanded(
            child: _SplashTexts(controller: controller, isTablet: true),
          ),
        ],
      ),
    );
  }
}

// ── Shared text + button + dots ────────────────────────────────────────────
class _SplashTexts extends StatelessWidget {
  final Splash2Controller controller;
  final bool isTablet;
  const _SplashTexts({required this.controller, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment:
      isTablet ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [

        // ── Tagline ──────────────────────────────────────────────────
        AppText(
          data: 'splash_tagline'.tr,
          fontSize: isTablet ? 28 : 22,
          color: const Color(0xFF2B3A5D),
          textAlign: isTablet ? TextAlign.start : TextAlign.center,
          fontWeight: FontWeight.w700,
        ),

        SizedBox(height: context.h(12)),

        // ── Description ──────────────────────────────────────────────
        AppText(
          data: 'splash_description'.tr,
          fontSize: isTablet ? 16 : 15,
          color: const Color(0xFF2B3A5D).withOpacity(0.7),
          textAlign: isTablet ? TextAlign.start : TextAlign.center,
          fontWeight: FontWeight.w400,
          maxLines: 5,
        ),

        SizedBox(height: context.h(36)),

        // ── Continue Button ───────────────────────────────────────────
        AppButton(
          buttonText: 'continue'.tr,
          onPressed: controller.goToLanguagePage,
          fillColor: const Color(0xFF2B3A5D),
          buttonWidth: isTablet ? context.w(240) : context.w(280),
          buttonHeight: 52,
          borderRadius: 16,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),

        SizedBox(height: context.h(24)),

        // ── Dot Indicator ─────────────────────────────────────────────
        Obx(() => Row(
          mainAxisAlignment: isTablet
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          children: List.generate(2, (index) {
            final isActive = index == controller.activeIndex.value;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              margin: EdgeInsets.symmetric(horizontal: context.w(4)),
              width: isActive ? context.w(20) : context.w(8),
              height: context.w(8),
              decoration: BoxDecoration(
                color: isActive
                    ? const Color(0xFF2B3A5D)
                    : const Color(0xFF2B3A5D).withOpacity(0.25),
                borderRadius: BorderRadius.circular(context.w(20)),
              ),
            );
          }),
        )),
      ],
    );
  }
}