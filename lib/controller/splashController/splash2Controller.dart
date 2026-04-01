// splash2_controller.dart
import 'package:get/get.dart';
import 'package:flutter_project/language_page.dart';

import '../../features/SplashScreen/splash_screen.dart';

class Splash2Controller extends GetxController {
  final RxInt activeIndex = 2.obs;

  void goToSplashScreen() {
    Get.off(() => const SplashScreen());
  }

  void goToLanguagePage() {
    Get.off(() => const LanguagePage());
  }
}