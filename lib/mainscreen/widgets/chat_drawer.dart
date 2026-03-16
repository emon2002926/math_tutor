import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../authpage/signin_page.dart';
import '../../core/app_text.dart';
import '../../core/utils/app_navigation.dart';
import '../controllers/chat_controller.dart';
import '../profile.dart';
import '../terms&conditionpage.dart';

class ChatDrawer extends StatelessWidget {
  final ChatController controller;
  const ChatDrawer({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Menu icon ───────────────────────────────
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            // ── New Chat ────────────────────────────────
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
                  icon: const Icon(Icons.edit_square,
                      size: 18, color: Colors.white),
                  label: const AppText(data: "New chat",
                      color: Colors.white, fontSize: 15)),
            ),

            const SizedBox(height: 8),
            const Divider(height: 1),

            // ── Profile ─────────────────────────────────
            ListTile(
              title: const AppText(data: "Profile"),
              onTap: () {
                AppNavigation.push(Profile());
              },
            ),
            const Divider(height: 1),

            // ── Terms ────────────────────────────────────
            ListTile(
              title: const AppText(data: "Terms and privacy policy"),
              onTap: () {
                Navigator.pop(context);
                AppNavigation.push(Termsconditionpage());
              },
            ),
            const Divider(height: 1),

            // ── History / Guest join prompt ─────────────
            Expanded(
              child: Obx(() {
                if (!controller.isLoggedIn) {
                  // Guest: History header + "Join" prompt at bottom
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ListTile(
                        title: AppText(data: "History"),
                        trailing: Icon(Icons.keyboard_arrow_down),
                      ),
                      const Expanded(child: SizedBox.shrink()),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const AppText(data: "Join to save your chats",
                                fontWeight: FontWeight.w600,
                                fontSize: 15),
                            const SizedBox(height: 12),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  AppNavigation.push(SigninPage());
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                  const Color(0xFF1F2A44),
                                  minimumSize:
                                  const Size(double.infinity, 44),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(8)),
                                ),
                                child: const AppText(data: "Login or Sign up",
                                    color: Colors.white)),
                          ],
                        ),
                      ),
                    ],
                  );
                }

                // ── Logged-in: History list ──────────────
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                        padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
                        child: AppText(data: "History",
                            fontWeight: FontWeight.w600,
                            fontSize: 15)),
                    Expanded(
                      child: controller.isLoadingSessions.value
                          ? const Center(
                          child: CircularProgressIndicator())
                          : controller.chatSessions.isEmpty
                          ? const Center(
                          child: AppText(data: "No chats yet",
                              color: Colors.grey))
                          : ListView.builder(
                        itemCount:
                        controller.chatSessions.length,
                        itemBuilder: (ctx, i) {
                          final session =
                          controller.chatSessions[i];
                          final title =
                              session['title'] as String? ??
                                  'Chat ${session['id']}';
                          return ListTile(
                            dense: true,
                            title: AppText(
                                data: title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                fontSize: 14),

                            onTap: () {
                              Navigator.pop(context);
                              controller.loadSession(
                                  session['id'] as int);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              }),
            ),

            const Divider(height: 1),

            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (controller.isLoggedIn) {
                    AppNavigation.pushAndClear(SigninPage());

                  } else {
                    AppNavigation.pushAndClear(SigninPage());

                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1F2A44),
                  minimumSize: const Size(double.infinity, 44),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: AppText(
                    data: controller.isLoggedIn ? "Log out" : "Log in",
                    color: Colors.white) ,
              ),
            ),
          ],
        ),
      ),
    );
  }
}