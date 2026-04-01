import 'package:flutter/material.dart';
import 'package:flutter_project/features/profile/models/user_profile.dart';
import 'package:get/get.dart';
import '../../../core/services/api_services.dart';
import '../../../core/util/app_navigation.dart';
import '../../../core/util/storage_service.dart';
import '../../../core/widgets/dialog/app_dialog.dart';
import '../../../core/widgets/snakbar/custom_snackbar.dart';
import '../../../core/widgets/text/app_text.dart';
import '../../auth/views/signin_page.dart';
import '../../language/controllers/language_controller.dart';
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

  void _showError(String message)   => CustomSnackBar.error(message);
  void _showSuccess(String message) => CustomSnackBar.success(message);

  // ── Fetch Profile ────────────────────────────────────────────────────────

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

  // ── Language Dialog ──────────────────────────────────────────────────────

  void showLanguageDialog(BuildContext context) {
    final langCtrl = LanguageController.to;

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Title ──
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1F2A44).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.language,
                        color: Color(0xFF1F2A44), size: 18),
                  ),
                  const SizedBox(width: 12),
                  AppText(
                    data: 'change_language'.tr,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2A44),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ── Options ──
              GetBuilder<LanguageController>(
                builder: (ctrl) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _languageOption(
                      label: 'English',
                      isSelected: ctrl.langCode == 'en',
                      onTap: () => langCtrl.selectLanguage('en'),
                    ),
                    const SizedBox(height: 8),
                    _languageOption(
                      label: 'Български',
                      isSelected: ctrl.langCode == 'bg',
                      onTap: () => langCtrl.selectLanguage('bg'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Actions ──
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: AppText(
                        data: 'cancel'.tr,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await langCtrl.confirmLanguage();
                        Navigator.pop(ctx);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1F2A44),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: AppText(
                        data: 'confirm'.tr,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _languageOption({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF1F2A44).withOpacity(0.06)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF1F2A44).withOpacity(0.3)
                : Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.language,
                size: 18,
                color: isSelected
                    ? const Color(0xFF1F2A44)
                    : Colors.grey.shade500),
            const SizedBox(width: 12),
            Expanded(
              child: AppText(
                data: label,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? const Color(0xFF1F2A44)
                    : Colors.grey.shade700,
              ),
            ),
            Icon(
              isSelected
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              size: 20,
              color: isSelected
                  ? const Color(0xFF1F2A44)
                  : Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  // ── Edit Username Dialog ─────────────────────────────────────────────────

  void showEditUsernameDialog(BuildContext context) {
    final usernameController = TextEditingController(text: userName.value);

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Title ──
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1F2A44).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.person_outline,
                        color: Color(0xFF1F2A44), size: 18),
                  ),
                  const SizedBox(width: 12),
                  AppText(
                    data: 'edit_username'.tr,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2A44),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ── Text field ──
              TextField(
                controller: usernameController,
                autofocus: true,
                style: const TextStyle(
                    fontSize: 15, color: Color(0xFF1F2A44)),
                decoration: InputDecoration(
                  hintText: 'username'.tr,
                  hintStyle: TextStyle(
                      color: Colors.grey.shade400, fontSize: 14),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: Color(0xFF1F2A44), width: 1.5),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ── Actions ──
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: AppText(
                        data: 'cancel'.tr,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Obx(() => ElevatedButton(
                      onPressed: isUpdating.value
                          ? null
                          : () => _updateUsername(
                          ctx, usernameController.text.trim()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1F2A44),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: isUpdating.value
                          ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      )
                          : AppText(
                        data: 'save'.tr,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    )),
                  ),
                ],
              ),
            ],
          ),
        ),
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

  // ── Delete Profile ───────────────────────────────────────────────────────

  Future<void> deleteProfile(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AppDialog(
        title: 'delete_account'.tr,
        description: 'delete_account_confirm'.tr,
        confirmText: 'delete'.tr,
        cancelText: 'cancel'.tr,
        onCancel: () => Navigator.pop(Get.context!, false),
        onConfirm: () => Navigator.pop(Get.context!, true),
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

  // ── Logout ───────────────────────────────────────────────────────────────

  Future<void> logout() async {
    final confirm = await Get.dialog<bool>(
      AppDialog(
        title: 'logout'.tr,
        description: 'logout_confirm'.tr,
        confirmText: 'logout'.tr,
        cancelText: 'cancel'.tr,
        onCancel: () => Get.back(result: false),
        onConfirm: () => Get.back(result: true),
      ),
    );

    if (confirm != true) return;

    await StorageService.logout();
    AppNavigation.pushAndClear(SignInPage());
  }
}