import 'package:get/get.dart';
import 'dart:ui';

import 'core/util/storage_service.dart';



class LanguageController extends GetxController {
  static LanguageController get to => Get.find();

  final _langCode = 'en'.obs;
  String get langCode => _langCode.value;

  @override
  void onInit() {
    super.onInit();
    _langCode.value = StorageService.language; // 'en' or 'bg'
    _applyLocale(_langCode.value);
  }

  void selectLanguage(String code) {
    _langCode.value = code;
    update();
  }

  Future<void> confirmLanguage() async {
    await StorageService.saveLanguage(_langCode.value);
    _applyLocale(_langCode.value);
  }

  void _applyLocale(String code) {
    // Must match the keys in AppTranslations: 'en_US' or 'bg_BG'
    final locale = code == 'bg'
        ? const Locale('bg', 'BG')
        : const Locale('en', 'US');
    Get.updateLocale(locale);
  }
}