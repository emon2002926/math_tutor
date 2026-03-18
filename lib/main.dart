import 'package:flutter/material.dart';
import 'package:flutter_project/SplashScreen/splash_screen.dart';
import 'package:flutter_project/core/utils/app_navigation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';

import 'app_translations.dart';
import 'controller/splashController/splash1Controller.dart';
import 'core/utils/api_service.dart';
import 'core/utils/storege_service.dart';
import 'language_controller.dart';



Future<void> main() async {
  await GetStorage.init();
  Get.lazyPut(() => SplashController());
  Get.put(ApiServices(baseUrl: 'https://mathapi.dsrt321.online'));
  Get.put(LanguageController()); // register language controller

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final savedLang = StorageService.language; // 'en' or 'bg'

    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: AppNavigation.navigatorKey,

          // ── Add these 3 lines ──
          translations: AppTranslations(),
          locale: savedLang == 'bg'
              ? const Locale('bg', 'BG')
              : const Locale('en', 'US'),
          fallbackLocale: const Locale('en', 'US'),
          // ───────────────────────

          home: child,
        );
      },
      child: SplashScreen(),
    );
  }
}