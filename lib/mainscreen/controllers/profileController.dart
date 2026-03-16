import 'package:flutter/material.dart';
import 'package:flutter_project/controller/ProfileController/user_profile.dart';
import 'package:flutter_project/core/utils/api_service.dart';
import 'package:flutter_project/core/utils/storege_service.dart';
import 'package:get/get.dart';
import 'package:flutter_project/authpage/signin_page.dart';

import '../../core/utils/app_navigation.dart';
import '../../services/profile_service.dart';


import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'dart:convert';

class ProfileController extends GetxController {
  final apiServices = Get.find<ApiServices>();
  final String? token = StorageService.accessToken;

  // ── Observable profile fields ──────────────────────────
  final profile   = Rxn<UserProfile>();
  final userName  = ''.obs;
  final userEmail = ''.obs;
  final userImage = ''.obs;

  // ── Observable states ──────────────────────────────────
  final isLoading  = false.obs;
  final isUpdating = false.obs;
  final isDeleting = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  // ── Helper: parse error message from HttpException body ──
  // Your ApiServices throws HttpException with body as raw JSON string
  // e.g. body: '{"detail": "Not found."}'
  String _parseError(HttpException e) {
    try {
      final decoded = jsonDecode(e.body ?? '{}') as Map<String, dynamic>;
      return decoded['detail']         ??
          decoded['message']        ??
          decoded['error']          ??
          'Something went wrong (${e.statusCode})';
    } catch (_) {
      return 'Something went wrong (${e.statusCode})';
    }
  }

  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade100,
      colorText: Colors.red.shade900,
      margin: const EdgeInsets.all(12),
    );
  }

  void _showSuccess(String message) {
    Get.snackbar(
      'Success',
      message,
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
    print("gjkfhag:$token");
    try {
      // ApiServices.get() → _handleResponse() → returns jsonDecode(body)
      // so response is already Map<String, dynamic>

      final response = await apiServices.get(
        '/api/users/profile/',
        headers: {'Authorization': 'Bearer $token'},
      );
      profile.value  = UserProfile.fromJson(response as Map<String, dynamic>);
      userName.value  = profile.value?.username ?? '';
      userEmail.value = profile.value?.email    ?? '';
      // userImage.value = profile.value?.image    ?? '';
    } on HttpException catch (e) {
      print('FetchProfile Error ${e.statusCode}: ${e.body}');
      _showError(_parseError(e));
    } finally {
      isLoading.value = false;
    }
  }

  // ===========================
  /// EDIT EMAIL DIALOG
  // ===========================
  void showEditEmailDialog(BuildContext context) {
    final emailController = TextEditingController(text: userEmail.value);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Email'),
        content: TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          Obx(() => ElevatedButton(
            onPressed: isUpdating.value
                ? null
                : () => _updateEmail(ctx, emailController.text.trim()),
            child: isUpdating.value
                ? const SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : const Text('Save'),
          )),
        ],
      ),
    );
  }

  Future<void> _updateEmail(BuildContext ctx, String newEmail) async {
    if (newEmail.isEmpty || newEmail == userEmail.value) {
      Navigator.pop(ctx);
      return;
    }

    isUpdating.value = true;
    try {
      // ApiServices.patch() → sends jsonEncode(body) automatically
      await apiServices.patch(
        '/api/users/profile/',
        headers: {'Authorization': 'Bearer $token'},
        body: {'email': newEmail},
      );
      userEmail.value = newEmail;
      Navigator.pop(ctx);
      _showSuccess('Email updated successfully');
    } on HttpException catch (e) {
      print('UpdateEmail Error ${e.statusCode}: ${e.body}');
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
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    isDeleting.value = true;
    try {
      // ApiServices.delete() → no body needed for profile delete
      await apiServices.delete(
        '/api/users/profile/',
        headers: {'Authorization': 'Bearer $token'},
      );
      await StorageService.logout();
      AppNavigation.pushAndClear(SigninPage());
    } on HttpException catch (e) {
      print('DeleteProfile Error ${e.statusCode}: ${e.body}');
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
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await StorageService.logout();
    AppNavigation.pushAndClear(SigninPage());
  }
}