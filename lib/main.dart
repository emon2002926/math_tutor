import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'features/language/data/app_translations.dart';
import 'features/SplashScreen/controllers/splash1Controller.dart';
import 'core/services/api_services.dart';
import 'core/util/app_navigation.dart';
import 'core/util/storage_service.dart';
import 'features/SplashScreen/views/splash_screen.dart';
import 'features/language/controllers/language_controller.dart';

Future<void> main() async {
  await GetStorage.init();
  Get.lazyPut(() => SplashController());
  Get.put(ApiServices(baseUrl: 'https://mathapi.dsrt321.online'));
  Get.put(LanguageController());

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