import 'package:flutter/material.dart';
import 'package:flutter_project/authpage/signin_page.dart';
import 'package:flutter_project/images.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'language_controller.dart';

     // your existing image constants


class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<LanguageController>()) {
      Get.put(LanguageController());
    }
    final langCtrl = LanguageController.to;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 22),

              Image.asset(AppImages.Toplogo, height: 200, width: 150),

              const SizedBox(height: 20),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'select_language'.tr,
                  style: GoogleFonts.montserrat(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // GetBuilder directly reads ctrl.langCode — no Obx needed
              GetBuilder<LanguageController>(
                builder: (ctrl) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: ctrl.langCode,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: const [
                        DropdownMenuItem(value: 'en', child: Text('English')),
                        DropdownMenuItem(value: 'bg', child: Text('Български')),
                      ],
                      onChanged: (value) {
                        if (value != null) ctrl.selectLanguage(value);
                      },
                    ),
                  ),
                ),
              ),

              const Spacer(), // fills remaining space — no overflow

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1F2A44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () async {
                    await langCtrl.confirmLanguage();
                    Get.off(() => const SignInPage());
                  },
                  child: Text(
                    'confirm'.tr,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
