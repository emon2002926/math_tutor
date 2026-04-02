import 'package:flutter/material.dart';
import 'package:flutter_project/core/constants/images.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

import '../../../core/util/screen_size.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/text/app_text.dart';
import '../../auth/views/signin_page.dart';
import '../controllers/language_controller.dart';



class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<LanguageController>()) {
      Get.put(LanguageController());
    }
    final langCtrl = LanguageController.to;
    final isTablet = context.isTabletDevice;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.pagePadding,
                vertical: context.h(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  SizedBox(height: context.h(22)),

                  // ── Logo ────────────────────────────────────────────
                  Center(
                    child: Image.asset(
                      AppImages.Toplogo,
                      height: context.h(isTablet ? 150 : 200),
                      width: context.w(isTablet ? 120 : 150),
                      fit: BoxFit.contain,
                    ),
                  ),

                  SizedBox(height: context.h(24)),

                  // ── Title ───────────────────────────────────────────
                  AppText(
                    data: 'select_language'.tr,
                    fontSize: isTablet ? 22 : 26,
                    fontWeight: FontWeight.bold,
                    googleFontFamily: GoogleFonts.montserrat,
                    color: const Color(0xFF1F2A44),
                  ),

                  SizedBox(height: context.h(16)),

                  // ── Language Options ─────────────────────────────────
                  GetBuilder<LanguageController>(
                    builder: (ctrl) => Column(
                      children: [
                        _languageTile(
                          context: context,
                          label: 'English',
                          value: 'en',
                          selectedValue: ctrl.langCode,
                          onTap: () => ctrl.selectLanguage('en'),
                        ),
                        SizedBox(height: context.h(10)),
                        _languageTile(
                          context: context,
                          label: 'Български',
                          value: 'bg',
                          selectedValue: ctrl.langCode,
                          onTap: () => ctrl.selectLanguage('bg'),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // ── Confirm Button ───────────────────────────────────
                  AppButton(
                    buttonText: 'confirm'.tr,
                    onPressed: () async {
                      await langCtrl.confirmLanguage();
                      Get.off(() => const SignInPage());
                    },
                    fillColor: const Color(0xFF1F2A44),
                    borderRadius: 16,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),

                  SizedBox(height: context.h(16)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _languageTile({
    required BuildContext context,
    required String label,
    required String value,
    required String selectedValue,
    required VoidCallback onTap,
  }) {
    final isSelected = value == selectedValue;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: context.w(20),
          vertical: context.h(16),
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF1F2A44).withOpacity(0.06)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(context.w(16)),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF1F2A44)
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // ── Flag / Icon ──
            Container(
              width: context.w(40),
              height: context.w(40),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF1F2A44).withOpacity(0.1)
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(context.w(10)),
              ),
              child: Icon(
                Icons.language,
                size: context.sp(20),
                color: isSelected
                    ? const Color(0xFF1F2A44)
                    : Colors.grey.shade500,
              ),
            ),

            SizedBox(width: context.w(14)),

            // ── Label ──
            Expanded(
              child: AppText(
                data: label,
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? const Color(0xFF1F2A44)
                    : Colors.grey.shade700,
              ),
            ),

            // ── Check ──
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isSelected
                  ? Icon(
                Icons.check_circle_rounded,
                key: const ValueKey('checked'),
                color: const Color(0xFF1F2A44),
                size: context.sp(22),
              )
                  : Icon(
                Icons.radio_button_unchecked,
                key: const ValueKey('unchecked'),
                color: Colors.grey.shade400,
                size: context.sp(22),
              ),
            ),
          ],
        ),
      ),
    );
  }
}