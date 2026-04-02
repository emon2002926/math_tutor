import 'package:flutter/material.dart';
import '../../../core/util/app_navigation.dart';
import '../../../core/util/screen_size.dart';
import '../../../core/util/storage_service.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/dialog/app_dialog.dart';
import '../../../core/widgets/text/app_text.dart';
import '../../auth/views/signin_page.dart';
import '../controllers/chat_controller.dart';
import '../../profile/views/profile_page.dart';
import '../../terms_condition/views/terms_and_condition_page.dart';
import 'package:get/get.dart';

import '../widgets/rename_dialog.dart';

class ChatDrawer extends StatelessWidget {
  final ChatController controller;
  const ChatDrawer({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = controller.isLoggedIn;

    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Menu icon ─────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: context.w(8), vertical: context.h(4)),
              child: IconButton(
                icon: Icon(Icons.menu, size: context.sp(22)),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            // ── New Chat ──────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.w(16)),
              child: AppButton(
                buttonText: 'new_chat'.tr,
                onPressed: () {
                  Navigator.pop(context);
                  controller.startNewChat();
                },
                fillColor: const Color(0xFF1F2A44),
                borderRadius: 8,
                buttonHeight: 44,
                fontSize: 15,
                prefixIcon: Icons.edit_square,
              ),
            ),

            SizedBox(height: context.h(8)),
            const Divider(height: 1),

            // ── Profile ───────────────────────────
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: context.w(16)),
              leading: Icon(Icons.person_outline,
                  size: context.sp(20), color: const Color(0xFF1F2A44)),
              title: AppText(
                data: 'profile'.tr,
                fontSize: 15,
                color: const Color(0xFF1F2A44),
              ),
              onTap: () => AppNavigation.push(ProfilePage()),
            ),
            const Divider(height: 1),

            // ── Terms ─────────────────────────────
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: context.w(16)),
              leading: Icon(Icons.shield_outlined,
                  size: context.sp(20), color: const Color(0xFF1F2A44)),
              title: AppText(
                data: 'terms_privacy'.tr,
                fontSize: 15,
                color: const Color(0xFF1F2A44),
              ),
              onTap: () {
                Navigator.pop(context);
                AppNavigation.push(TermsConditionPage());
              },
            ),
            const Divider(height: 1),

            // ── History header + list ──────────────
            Expanded(
              child: Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: controller.toggleHistoryExpanded,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: context.w(16),
                          vertical: context.h(14)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                            data: 'history'.tr,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: const Color(0xFF1F2A44),
                          ),
                          Icon(
                            controller.isHistoryExpanded.value
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            size: context.sp(20),
                            color: const Color(0xFF1F2A44),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (controller.isHistoryExpanded.value && isLoggedIn)
                    Expanded(child: _buildLoggedInHistory(context)),
                ],
              )),
            ),

            const Divider(height: 1),

            // ── Bottom button ─────────────────────
            Padding(
              padding: EdgeInsets.all(context.w(16)),
              child: isLoggedIn
                  ? AppButton(
                buttonText: 'logout'.tr,
                onPressed: () => _showLogoutConfirm(context),
                fillColor: const Color(0xFF1F2A44),
                borderRadius: 8,
                buttonHeight: 44,
                fontSize: 15,
              )
                  : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText(
                    data: 'join_to_save'.tr,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: context.h(12)),
                  AppButton(
                    buttonText: 'login_or_signup'.tr,
                    onPressed: () {
                      Navigator.pop(context);
                      AppNavigation.push(SignInPage());
                    },
                    fillColor: const Color(0xFF1F2A44),
                    borderRadius: 8,
                    buttonHeight: 44,
                    fontSize: 15,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════
  // HISTORY LIST
  // ════════════════════════════════════════════════════════

  Widget _buildLoggedInHistory(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingSessions.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.chatSessions.isEmpty) {
        return Center(
          child: AppText(
              data: 'no_chats'.tr,
              color: Colors.grey,
              fontSize: 14),
        );
      }
      return ListView.builder(
        padding: EdgeInsets.symmetric(vertical: context.h(4)),
        itemCount: controller.chatSessions.length,
        itemBuilder: (ctx, i) {
          final session = controller.chatSessions[i];
          final title =
              session['title'] as String? ?? 'Chat ${session['id']}';
          final id = session['id'] as int;

          return ListTile(
            dense: true,
            contentPadding:
            EdgeInsets.symmetric(horizontal: context.w(16)),
            title: AppText(
              data: title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
            onTap: () {
              Navigator.pop(context);
              controller.loadSession(id);
            },
            trailing: PopupMenuButton<String>(
              icon: Icon(Icons.more_horiz,
                  size: context.sp(18), color: Colors.grey),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.w(16))),
              elevation: 8,
              shadowColor: Colors.black.withOpacity(0.15),
              color: Colors.white,
              onSelected: (value) {
                if (value == 'rename') {
                  _showRenameDialog(context, id, title);
                } else if (value == 'delete') {
                  _showDeleteConfirm(context, id);
                }
              },
              itemBuilder: (_) => [
                _popupItem(
                  context: context,
                  value: 'rename',
                  label: 'rename_chat'.tr,
                  icon: Icons.edit_outlined,
                  color: const Color(0xFF1F2A44),
                ),
                _popupItem(
                  context: context,
                  value: 'delete',
                  label: 'delete'.tr,
                  icon: Icons.delete_outline_rounded,
                  color: Colors.red,
                ),
              ],
            ),
          );
        },
      );
    });
  }

  // ════════════════════════════════════════════════════════
  // POPUP MENU ITEM
  // ════════════════════════════════════════════════════════

  PopupMenuItem<String> _popupItem({
    required BuildContext context,
    required String value,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    final isDelete = value == 'delete';
    return PopupMenuItem<String>(
      value: value,
      padding: EdgeInsets.symmetric(
          horizontal: context.w(16), vertical: context.h(4)),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: context.w(12), vertical: context.h(10)),
        decoration: BoxDecoration(
          color: isDelete
              ? Colors.red.withOpacity(0.06)
              : const Color(0xFF1F2A44).withOpacity(0.05),
          borderRadius: BorderRadius.circular(context.w(10)),
        ),
        child: Row(
          children: [
            Container(
              width: context.w(32),
              height: context.w(32),
              decoration: BoxDecoration(
                color: isDelete
                    ? Colors.red.withOpacity(0.1)
                    : const Color(0xFF1F2A44).withOpacity(0.08),
                borderRadius: BorderRadius.circular(context.w(8)),
              ),
              child: Icon(icon, size: context.sp(16), color: color),
            ),
            SizedBox(width: context.w(12)),
            AppText(
              data: label,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════
  // DIALOGS
  // ════════════════════════════════════════════════════════

  void _showLogoutConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AppDialog(
        title: 'logout'.tr,
        description: 'logout_confirm'.tr,
        confirmText: 'logout'.tr,
        cancelText: 'cancel'.tr,
        onCancel: () => Navigator.pop(context),
        onConfirm: () {
          Navigator.pop(context);
          Navigator.pop(context);
          StorageService.logout();
          AppNavigation.pushAndClear(SignInPage());
        },
      ),
    );
  }

  void _showRenameDialog(BuildContext context, int id, String currentTitle) {
    showDialog(
      context: context,
      builder: (_) => RenameDialog(
        currentTitle: currentTitle,
        onSave: (newTitle) {
          Navigator.pop(context);
          controller.renameSession(id, newTitle);
        },
      ),
    );
  }

  void _showDeleteConfirm(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (_) => AppDialog(
        title: 'delete_chat'.tr,
        description: 'delete_chat_confirm'.tr,
        confirmText: 'delete'.tr,
        cancelText: 'cancel'.tr,
        onCancel: () => Navigator.pop(context),
        onConfirm: () {
          Navigator.pop(context);
          Navigator.pop(context);
          controller.deleteSession(id);
        },
      ),
    );
  }
}