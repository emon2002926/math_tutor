import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'core/constants/app_constant.dart';
import 'features/language/data/app_translations.dart';
import 'features/SplashScreen/controllers/splash1Controller.dart';
import 'core/services/api_services.dart';
import 'core/util/app_navigation.dart';
import 'core/util/storage_service.dart';
import 'features/SplashScreen/views/splash_screen.dart';
import 'features/language/controllers/language_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Get.lazyPut(() => SplashController());
  Get.put(ApiServices(baseUrl: 'https://mathapi.dsrt321.online'));
  Get.put(LanguageController());

  // Lock to portrait on phones, allow both on tablets
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final savedLang = StorageService.language;

    return ScreenUtilInit(
      // Match your ScreenSize extension's design frame exactly
      designSize: const Size(393, 852),
      minTextAdapt: true,
      // splitScreenMode: true,
      useInheritedMediaQuery: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: AppNavigation.navigatorKey,
          translations: AppTranslations(),
          locale: savedLang == 'bg'
              ? const Locale('bg', 'BG')
              : const Locale('en', 'US'),
          fallbackLocale: const Locale('en', 'US'),
          theme: ThemeData(
            // Prevents system font scaling from breaking your UI
            textTheme: Typography.englishLike2018
                .apply(fontSizeFactor: 1.0),
          ),
          builder: (context, child) {
            // Clamp system text scale — critical for tablets
            final mediaQuery = MediaQuery.of(context);
            return MediaQuery(
              data: mediaQuery.copyWith(
                textScaler: TextScaler.linear(
                  mediaQuery.textScaleFactor.clamp(0.8, 1.2),
                ),
              ),
              child: child!,
            );
          },
          home: child,
        );
      },
      child: SplashScreen(),
    );
  }
}