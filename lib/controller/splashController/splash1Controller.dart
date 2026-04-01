// splash_controller.dart
import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter_project/mainscreen/chat_page.dart';
import 'package:flutter_project/SplashScreen/splash_screen2.dart';
import 'package:get_storage/get_storage.dart';

import '../../core/util/app_navigation.dart';
import '../../core/util/storage_service.dart';

/*
class SplashController extends GetxController {
  final RxInt activeIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _navigate();
  }

  void _navigate() {
    final String? token = StorageService.accessToken;
    print("fdlgkh: $token");

    Future.delayed(const Duration(seconds: 4), () {
      if (token == null) {
        Get.off(() => SplashScreen2());
      } else {
        Get.off(() => Chatingpage());
      }
    });
  }
}
*/



class SplashController extends GetxController {
  final box = GetStorage();
  final RxInt activeIndex = 0.obs;

  Timer? _dotTimer;

  @override
  void onInit() {
    super.onInit();
    _startDotAnimation();
    _startTimer();
  }

  void _startDotAnimation() {
    _dotTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      activeIndex.value = activeIndex.value == 0 ? 1 : 0;
    });
  }

  void _startTimer() {
    Timer(const Duration(seconds: 3), () {
      String? accessToken = StorageService.accessToken;
      print("fgfghjh:$accessToken");
      if (accessToken != null && accessToken.isNotEmpty) {
        AppNavigation.pushAndClear(ChatPage());

      } else {
        AppNavigation.pushAndClear(SplashScreen2());

      }
    });
  }

  @override
  void onClose() {
    _dotTimer?.cancel(); // always cancel timer to avoid memory leaks
    super.onClose();
  }
}