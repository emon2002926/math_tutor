import 'package:flutter/material.dart';
import 'package:flutter_project/core/utils/storege_service.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import '../../authpage/signin_page.dart';
import '../../core/app_text.dart';
import '../../core/utils/app_navigation.dart';
import '../controllers/chat_controller.dart';
import '../profile.dart';
import '../terms&conditionpage.dart';
import 'package:get/get.dart';

class ChatDrawer extends StatefulWidget {
  final ChatController controller;
  const ChatDrawer({super.key, required this.controller});

  @override
  State<ChatDrawer> createState() => _ChatDrawerState();
}

class _ChatDrawerState extends State<ChatDrawer> {
  bool _historyExpanded = false;

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
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
                label: AppText(
                  data: 'new_chat'.tr,
                  color: Colors.white,
                  fontSize: 15,
                ),
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

            // ── History header ───────────────────
            InkWell(
              onTap: () =>
                  setState(() => _historyExpanded = !_historyExpanded),
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
                    Icon(_historyExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down),
                  ],
                ),
              ),
            ),

            // ── History list ─────────────────────
            if (_historyExpanded)
              Expanded(
                child: isLoggedIn
                    ? _buildLoggedInHistory(controller)
                    : const SizedBox.shrink(),
              )
            else
              const Spacer(),

            const Divider(height: 1),

            // ── Bottom button ────────────────────
            Padding(
              padding: const EdgeInsets.all(16),
              child: isLoggedIn
                  ? ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  StorageService.logout();
                  AppNavigation.pushAndClear(SignInPage());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1F2A44),
                  minimumSize: const Size(double.infinity, 44),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: AppText(
                  data: 'logout'.tr,
                  color: Colors.white,
                ),
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
                      data: 'login_or_signup'.tr,
                      color: Colors.white,
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

  Widget _buildLoggedInHistory(ChatController controller) {
    return Obx(() {
      if (controller.isLoadingSessions.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.chatSessions.isEmpty) {
        return Center(
          child: AppText(data: 'no_chats'.tr, color: Colors.grey),
        );
      }
      return ListView.builder(
        itemCount: controller.chatSessions.length,
        itemBuilder: (ctx, i) {
          final session = controller.chatSessions[i];
          final title =
              session['title'] as String? ?? 'Chat ${session['id']}';
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
                  borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              onSelected: (value) {
                if (value == 'rename') {
                  _showRenameDialog(context, controller, id, title);
                } else if (value == 'delete') {
                  _showDeleteConfirm(context, controller, id);
                }
              },
              itemBuilder: (_) => [
                _popupItem(
                  value: 'rename',
                  label: 'Rename',
                  icon: Icons.edit_outlined,
                  color: Colors.black87,
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
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(color: color, fontSize: 14)),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════
  // DIALOG — Rename (delegates to _RenameDialog widget)
  // ════════════════════════════════════════════════════════

  void _showRenameDialog(BuildContext context, ChatController controller,
      int id, String currentTitle) {
    showDialog(
      context: context,
      builder: (_) => _RenameDialog(
        currentTitle: currentTitle,
        onSave: (newTitle) {
          Navigator.pop(context);
          controller.renameSession(id, newTitle);
        },
      ),
    );
  }

  // ════════════════════════════════════════════════════════
  // DIALOG — Delete confirm
  // ════════════════════════════════════════════════════════

  void _showDeleteConfirm(
      BuildContext context, ChatController controller, int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Chat'),
        content:
        const Text('This chat will be permanently deleted. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // close drawer
              controller.deleteSession(id);
            },
            child: const Text('Delete',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}



class _RenameDialog extends StatefulWidget {
  final String currentTitle;
  final ValueChanged<String> onSave;

  const _RenameDialog({
    required this.currentTitle,
    required this.onSave,
  });

  @override
  State<_RenameDialog> createState() => _RenameDialogState();
}

class _RenameDialogState extends State<_RenameDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentTitle);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Rename Chat'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(hintText: 'Enter new name'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1F2A44),
          ),
          onPressed: () {
            final newTitle = _controller.text.trim();
            if (newTitle.isNotEmpty && newTitle != widget.currentTitle) {
              widget.onSave(newTitle);
            }
          },
          child: const Text('Save', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}