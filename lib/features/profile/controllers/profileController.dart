import 'package:flutter/material.dart';
import 'package:flutter_project/features/profile/models/user_profile.dart';
import 'package:get/get.dart';
import '../../../core/services/api_services.dart';
import '../../../core/util/app_navigation.dart';
import '../../../core/util/screen_size.dart';
import '../../../core/util/storage_service.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/dialog/app_dialog.dart';
import '../../../core/widgets/snakbar/custom_snackbar.dart';
import '../../../core/widgets/text/app_text.dart';
import '../../../core/widgets/text/text_field/AppTextFiled.dart';
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
    final isTablet = context.isTabletDevice;

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.w(20))),
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.symmetric(
          horizontal: isTablet
              ? context.screenWidth * 0.30
              : context.w(24),
          vertical: context.h(40),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.w(28),
            vertical: context.h(32),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Title ──
              Row(
                children: [
                  Container(
                    width: context.w(38),
                    height: context.w(38),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1F2A44).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(context.w(10)),
                    ),
                    child: Icon(Icons.language,
                        color: const Color(0xFF1F2A44),
                        size: context.sp(18)),
                  ),
                  SizedBox(width: context.w(12)),
                  AppText(
                    data: 'change_language'.tr,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2A44),
                  ),
                ],
              ),

              SizedBox(height: context.h(24)),

              // ── Options ──
              GetBuilder<LanguageController>(
                builder: (ctrl) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _languageOption(
                      context: context,
                      label: 'English',
                      isSelected: ctrl.langCode == 'en',
                      onTap: () => langCtrl.selectLanguage('en'),
                    ),
                    SizedBox(height: context.h(10)),
                    _languageOption(
                      context: context,
                      label: 'Български',
                      isSelected: ctrl.langCode == 'bg',
                      onTap: () => langCtrl.selectLanguage('bg'),
                    ),
                  ],
                ),
              ),

              SizedBox(height: context.h(32)),

              // ── Actions ──
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      buttonText: 'cancel'.tr,
                      onPressed: () => Navigator.pop(ctx),
                      fillColor: Colors.transparent,
                      borderColor: Colors.grey.shade300,
                      borderWidth: 1,
                      textColor: Colors.grey.shade600,
                      borderRadius: 12,
                      buttonHeight: 52,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: context.w(12)),
                  Expanded(
                    child: AppButton(
                      buttonText: 'confirm'.tr,
                      onPressed: () async {
                        await langCtrl.confirmLanguage();
                        Navigator.pop(ctx);
                      },
                      fillColor: const Color(0xFF1F2A44),
                      borderRadius: 12,
                      buttonHeight: 52,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
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
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.w(16),
          vertical: context.h(12),
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF1F2A44).withOpacity(0.06)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(context.w(12)),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF1F2A44).withOpacity(0.3)
                : Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.language,
              size: context.sp(18),
              color: isSelected
                  ? const Color(0xFF1F2A44)
                  : Colors.grey.shade500,
            ),
            SizedBox(width: context.w(12)),
            Expanded(
              child: AppText(
                data: label,
                fontSize: 14,
                fontWeight:
                isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? const Color(0xFF1F2A44)
                    : Colors.grey.shade700,
              ),
            ),
            Icon(
              isSelected
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              size: context.sp(20),
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
    final isTablet = context.isTabletDevice;

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.w(20))),
        backgroundColor: Colors.white,
        // ✅ Wider inset on tablets to constrain dialog width
        insetPadding: EdgeInsets.symmetric(
          horizontal: isTablet
              ? context.screenWidth * 0.25  // 50% of screen on tablet
              : context.w(24),
          vertical: context.h(40),
        ),
        child: Padding(
          padding: EdgeInsets.all(context.w(24)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Title ──
              Row(
                children: [
                  Container(
                    width: context.w(38),
                    height: context.w(38),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1F2A44).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(context.w(10)),
                    ),
                    child: Icon(Icons.person_outline,
                        color: const Color(0xFF1F2A44),
                        size: context.sp(18)),
                  ),
                  SizedBox(width: context.w(12)),
                  AppText(
                    data: 'edit_username'.tr,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2A44),
                  ),
                ],
              ),

              SizedBox(height: context.h(20)),

              // ── Text field ──
              AppTextField(
                hintText: 'username'.tr,
                controller: usernameController,
                focusedErrorBorderColor: const Color(0xFF1F2A44),
                prefixIcon: Icons.person_outline,
              ),

              SizedBox(height: context.h(24)),

              // ── Actions ──
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      buttonText: 'cancel'.tr,
                      onPressed: () => Navigator.pop(ctx),
                      fillColor: Colors.transparent,
                      borderColor: Colors.grey.shade300,
                      borderWidth: 1,
                      textColor: Colors.grey.shade600,
                      borderRadius: 12,
                      buttonHeight: 48,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: context.w(12)),
                  Expanded(
                    child: Obx(() => AppButton(
                      buttonText: 'save'.tr,
                      onPressed: isUpdating.value
                          ? null
                          : () => _updateUsername(
                          ctx, usernameController.text.trim()),
                      isLoading: isUpdating.value,
                      fillColor: const Color(0xFF1F2A44),
                      borderRadius: 12,
                      buttonHeight: 48,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
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