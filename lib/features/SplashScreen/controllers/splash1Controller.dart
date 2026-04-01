// splash_controller.dart
import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/util/app_navigation.dart';
import '../../../core/util/storage_service.dart';
import '../views/splash_screen2.dart';
import '../../chat/views/chat_page.dart';

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