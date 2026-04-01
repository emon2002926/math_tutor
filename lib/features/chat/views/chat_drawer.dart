import 'package:flutter/material.dart';
import '../../../core/util/app_navigation.dart';
import '../../../core/util/storage_service.dart';
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
            // ── Menu icon ───────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            // ── New Chat ─────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  controller.startNewChat();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1F2A44),
                  minimumSize: const Size(double.infinity, 44),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.edit_square, size: 18, color: Colors.white),
                label: AppText(data: 'new_chat'.tr, color: Colors.white, fontSize: 15),
              ),
            ),

            const SizedBox(height: 8),
            const Divider(height: 1),

            // ── Profile ──────────────────────────
            ListTile(
              title: AppText(data: 'profile'.tr),
              onTap: () => AppNavigation.push(ProfilePage()),
            ),
            const Divider(height: 1),

            // ── Terms ────────────────────────────
            ListTile(
              title: AppText(data: 'terms_privacy'.tr),
              onTap: () {
                Navigator.pop(context);
                AppNavigation.push(TermsConditionPage());
              },
            ),
            const Divider(height: 1),

            // ── History header + list ─────────────
            Expanded(
              child: Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: controller.toggleHistoryExpanded,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                            data: 'history'.tr,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                          Icon(controller.isHistoryExpanded.value
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down),
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

            // ── Bottom button ────────────────────
            Padding(
              padding: const EdgeInsets.all(16),
              child: isLoggedIn
                  ? ElevatedButton(
                onPressed: () => _showLogoutConfirm(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1F2A44),
                  minimumSize: const Size(double.infinity, 44),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: AppText(data: 'logout'.tr, color: Colors.white),
              )
                  : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText(
                    data: 'join_to_save'.tr,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      AppNavigation.push(SignInPage());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1F2A44),
                      minimumSize: const Size(double.infinity, 44),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: AppText(
                        data: 'login_or_signup'.tr, color: Colors.white,
                    ),
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
        return Center(child: AppText(data: 'no_chats'.tr, color: Colors.grey));
      }
      return ListView.builder(
        itemCount: controller.chatSessions.length,
        itemBuilder: (ctx, i) {
          final session = controller.chatSessions[i];
          final title = session['title'] as String? ?? 'Chat ${session['id']}';
          final id = session['id'] as int;

          return ListTile(
            dense: true,
            title: AppText(
              data: title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              fontSize: 14,
              color: Colors.grey,
            ),
            onTap: () {
              Navigator.pop(context);
              controller.loadSession(id);
            },
            trailing: PopupMenuButton<String>(
              icon: const Icon(Icons.more_horiz, size: 18, color: Colors.grey),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
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
                  value: 'rename',
                  label: 'Rename',
                  icon: Icons.edit_outlined,
                  color: const Color(0xFF1F2A44),
                ),
                _popupItem(
                  value: 'delete',
                  label: 'Delete',
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
    required String value,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    final isDelete = value == 'delete';
    return PopupMenuItem<String>(
      value: value,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isDelete
              ? Colors.red.withOpacity(0.06)
              : const Color(0xFF1F2A44).withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isDelete
                    ? Colors.red.withOpacity(0.1)
                    : const Color(0xFF1F2A44).withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 16, color: color),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
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
