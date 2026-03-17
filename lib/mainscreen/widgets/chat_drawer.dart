import 'package:flutter/material.dart';
import '../../authpage/signin_page.dart';
import '../../core/app_text.dart';
import '../../core/utils/app_navigation.dart';
import '../controllers/chat_controller.dart';
import '../profile.dart';
import '../terms&conditionpage.dart';

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
                label: const AppText(data: "New chat", color: Colors.white, fontSize: 15),
              ),
            ),

            const SizedBox(height: 8),
            const Divider(height: 1),

            // ── Profile ──────────────────────────
            ListTile(
              title: const AppText(data: "Profile"),
              onTap: () => AppNavigation.push(Profile()),
            ),
            const Divider(height: 1),

            // ── Terms ────────────────────────────
            ListTile(
              title: const AppText(data: "Terms and privacy policy"),
              onTap: () {
                Navigator.pop(context);
                AppNavigation.push(Termsconditionpage());
              },
            ),
            const Divider(height: 1),

            // ── History header ───────────────────
            InkWell(
              onTap: () => setState(() => _historyExpanded = !_historyExpanded),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const AppText(data: "History", fontWeight: FontWeight.w600, fontSize: 15),
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
                  AppNavigation.pushAndClear(SignInPage());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1F2A44),
                  minimumSize: const Size(double.infinity, 44),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const AppText(data: "Log out", color: Colors.white),
              )
                  : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AppText(
                      data: "Join to save your chats",
                      fontWeight: FontWeight.w600,
                      fontSize: 15),
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
                    child: const AppText(
                        data: "Login or Sign up", color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Plain StatefulWidget method — no Obx needed,
  // GetX rebuilds this via the outer setState when sessions load
  Widget _buildLoggedInHistory(ChatController controller) {
    if (controller.isLoadingSessions.value) {
      return const Center(child: CircularProgressIndicator());
    }
    if (controller.chatSessions.isEmpty) {
      return const Center(
          child: AppText(data: "No chats yet", color: Colors.grey));
    }
    return ListView.builder(
      itemCount: controller.chatSessions.length,
      itemBuilder: (ctx, i) {
        final session = controller.chatSessions[i];
        final title = session['title'] as String? ?? 'Chat ${session['id']}';
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
            controller.loadSession(session['id'] as int);
          },
        );
      },
    );
  }
}