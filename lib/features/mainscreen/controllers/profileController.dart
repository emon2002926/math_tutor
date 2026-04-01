import 'package:flutter/material.dart';
import 'package:flutter_project/controller/ProfileController/user_profile.dart';
import 'package:get/get.dart';
import '../../../core/services/api_services.dart';
import '../../../core/util/app_navigation.dart';
import '../../../core/util/storage_service.dart';
import '../../../core/widgets/text/app_text.dart';
import '../../../language_controller.dart';
import '../../authpage/views/signin_page.dart';
import 'dart:convert';



class ProfileController extends GetxController {
  final apiServices = Get.find<ApiServices>();
  final String? token = StorageService.accessToken;

  final profile   = Rxn<UserProfile>();
  final userName  = ''.obs;
  final userEmail = ''.obs;
  final userImage = ''.obs;

  final isLoading  = false.obs;
  final isUpdating = false.obs;
  final isDeleting = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  String _parseError(HttpException e) {
    try {
      final decoded = jsonDecode(e.body ?? '{}') as Map<String, dynamic>;
      return decoded['detail'] ?? decoded['message'] ?? decoded['error'] ??
          'Something went wrong (${e.statusCode})';
    } catch (_) {
      return 'Something went wrong (${e.statusCode})';
    }
  }

  void _showError(String message) {
    Get.snackbar(
      'error'.tr, message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade100,
      colorText: Colors.red.shade900,
      margin: const EdgeInsets.all(12),
    );
  }

  void _showSuccess(String message) {
    Get.snackbar(
      'success'.tr, message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade900,
      margin: const EdgeInsets.all(12),
    );
  }

  // ===========================
  /// FETCH PROFILE
  // ===========================
  Future<void> fetchProfile() async {
    isLoading.value = true;
    try {
      final response = await apiServices.get(
        '/api/users/profile/',
        headers: {'Authorization': 'Bearer $token'},
      );
      profile.value  = UserProfile.fromJson(response as Map<String, dynamic>);
      userName.value  = profile.value?.username ?? '';
      userEmail.value = profile.value?.email    ?? '';
    } on HttpException catch (e) {
      _showError(_parseError(e));
    } finally {
      isLoading.value = false;
    }
  }

  // ===========================
  /// CHANGE LANGUAGE DIALOG
  // ===========================
  void showLanguageDialog(BuildContext context) {
    final langCtrl = LanguageController.to;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: AppText(
          data: 'change_language'.tr,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        content: GetBuilder<LanguageController>(
          builder: (ctrl) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // English option
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.language),
                title: const AppText(data: 'English', fontSize: 15),
                trailing: ctrl.langCode == 'en'
                    ? const Icon(Icons.check_circle, color: Color(0xFF1F2A44))
                    : const Icon(Icons.radio_button_unchecked, color: Colors.grey),
                onTap: () {
                  langCtrl.selectLanguage('en');
                },
              ),
              const Divider(height: 1),
              // Bulgarian option
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.language),
                title: const AppText(data: 'Български', fontSize: 15),
                trailing: ctrl.langCode == 'bg'
                    ? const Icon(Icons.check_circle, color: Color(0xFF1F2A44))
                    : const Icon(Icons.radio_button_unchecked, color: Colors.grey),
                onTap: () {
                  langCtrl.selectLanguage('bg');
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: AppText(data: 'cancel'.tr, fontSize: 14),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1F2A44),
            ),
            onPressed: () async {
              await langCtrl.confirmLanguage(); // saves + applies locale
              Navigator.pop(ctx);
            },
            child: AppText(
              data: 'confirm'.tr,
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================
  /// EDIT USERNAME DIALOG
  // ===========================
  void showEditUsernameDialog(BuildContext context) {
    final usernameController = TextEditingController(text: userName.value);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: AppText(
          data: 'edit_username'.tr,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        content: TextField(
          controller: usernameController,
          decoration: InputDecoration(
            labelText: 'username'.tr,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: AppText(data: 'cancel'.tr, fontSize: 14),
          ),
          Obx(() => ElevatedButton(
            onPressed: isUpdating.value
                ? null
                : () => _updateUsername(ctx, usernameController.text.trim()),
            child: isUpdating.value
                ? const SizedBox(
              height: 16, width: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : AppText(data: 'save'.tr, fontSize: 14),
          )),
        ],
      ),
    );
  }

  Future<void> _updateUsername(BuildContext ctx, String newValue) async {
    if (newValue.isEmpty || newValue == userName.value) {
      Navigator.pop(ctx);
      return;
    }
    isUpdating.value = true;
    try {
      await apiServices.put(
        '/api/users/profile/',
        headers: {'Authorization': 'Bearer $token'},
        body: {'username': newValue},
      );
      userName.value = newValue;
      Navigator.pop(ctx);
      _showSuccess('username_updated'.tr);
    } on HttpException catch (e) {
      _showError(_parseError(e));
    } finally {
      isUpdating.value = false;
    }
  }

  // ===========================
  /// DELETE PROFILE
  // ===========================
  Future<void> deleteProfile(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: AppText(
          data: 'delete_account'.tr,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        content: AppText(
          data: 'delete_account_confirm'.tr,
          fontSize: 14,
          color: Colors.black54,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: AppText(data: 'cancel'.tr, fontSize: 14),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: AppText(data: 'delete'.tr, fontSize: 14, color: Colors.red),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    isDeleting.value = true;
    try {
      await apiServices.delete(
        '/api/users/profile/',
        headers: {'Authorization': 'Bearer $token'},
      );
      await StorageService.logout();
      AppNavigation.pushAndClear(SignInPage());
    } on HttpException catch (e) {
      _showError(_parseError(e));
    } finally {
      isDeleting.value = false;
    }
  }

  // ===========================
  /// LOGOUT
  // ===========================
  Future<void> logout() async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: AppText(
          data: 'logout'.tr,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        content: AppText(data: 'logout_confirm'.tr, fontSize: 14),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: AppText(data: 'cancel'.tr, fontSize: 14),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: AppText(data: 'logout'.tr, fontSize: 14, color: Colors.red),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await StorageService.logout();
    AppNavigation.pushAndClear(SignInPage());
  }
}