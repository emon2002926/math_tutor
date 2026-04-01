import 'package:flutter/material.dart';
import 'package:flutter_project/features/chat/views/chat_drawer.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/widgets/text/app_text.dart';
import '../controllers/chat_controller.dart';
import '../models/chat_message.dart';
import '../widgets/ai_bubble.dart';
import '../widgets/fullImage_preview.dart';
import '../widgets/user_bubble.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatController controller = Get.put(ChatController());

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
      ),
      drawer: ChatDrawer(controller: controller),
      body: SafeArea(
        child: Obx(() => controller.messages.isEmpty
            ? const _EmptyState()
            : _MessageList(controller: controller)),
      ),
      bottomNavigationBar: Builder(
        builder: (ctx) => Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: _ChatInputBar(controller: controller),
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}

// ── Empty State ────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.auto_awesome, size: 10, color: Colors.blue.shade200),
              const SizedBox(width: 40),
              Icon(Icons.auto_awesome,
                  size: 14, color: Colors.yellow.shade400),
              const SizedBox(width: 20),
              Icon(Icons.auto_awesome, size: 8, color: Colors.pink.shade200),
            ],
          ),
          const SizedBox(height: 24),
          AppText(
            data: 'chat_empty_title'.tr,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            googleFontFamily:GoogleFonts.montserrat ,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.auto_awesome,
                  size: 8, color: Colors.purple.shade200),
              const SizedBox(width: 20),
              Icon(Icons.auto_awesome,
                  size: 22, color: Colors.yellow.shade400),
              const SizedBox(width: 10),
              Icon(Icons.auto_awesome,
                  size: 10, color: Colors.blue.shade300),
              const SizedBox(width: 30),
              Icon(Icons.auto_awesome,
                  size: 8, color: Colors.orange.shade200),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Message List ───────────────────────────────────────────────────────────
class _MessageList extends StatefulWidget {
  final ChatController controller;
  const _MessageList({required this.controller});

  @override
  State<_MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<_MessageList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    ever(widget.controller.messages, (_) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _scrollToBottom());
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final msgs = widget.controller.messages;
      return ListView.builder(
        controller: _scrollController,
        padding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: msgs.length,
        itemBuilder: (_, i) {
          final msg = msgs[i];
          return msg.sender == MessageSender.user
              ? UserBubble(message: msg)
              : AiBubble(message: msg);
        },
      );
    });
  }
}

class _ChatInputBar extends StatelessWidget {
  final ChatController controller;
  const _ChatInputBar({required this.controller});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(color: Color(0xFF1F2A44)),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [


            Obx(() {
              if (controller.selectedImage.value == null) {
                return const SizedBox.shrink();
              }
              final file = controller.selectedImage.value!;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // ── Thumbnail ──
                        GestureDetector(
                          onTap: () => FullImagePreview.open(context, file: file),
                          child: Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.15),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.35),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(13),
                              child: Image.file(
                                file,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),

                        // ── ✕ remove button ──
                        Positioned(
                          top: -6,
                          right: -6,
                          child: GestureDetector(
                            onTap: controller.removeImage,
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade800,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.4),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 13,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),

            // ── Audio preview ──────────────────────────────────────────
            Obx(() {
              if (controller.selectedAudio.value == null) {
                return const SizedBox.shrink();
              }
              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.audiotrack,
                        color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: AppText(
                        data: 'audio_ready'.tr,
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                    GestureDetector(
                      onTap: controller.removeAudio,
                      child: const Icon(Icons.close,
                          color: Colors.white70, size: 18),
                    ),
                  ],
                ),
              );
            }),

            // ── Main input row ─────────────────────────────────────────
            Row(
              children: [

                // Mic
                Obx(() => GestureDetector(
                  onTap: controller.toggleRecording,
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: controller.isRecording.value
                          ? Colors.red
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      controller.isRecording.value
                          ? Icons.stop
                          : Icons.mic,
                      color: Colors.white,
                    ),
                  ),
                )),

                // Image picker icon
                GestureDetector(
                  onTap: controller.pickImage,
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.image_outlined,
                        color: Colors.white, size: 20),
                  ),
                ),

                const SizedBox(width: 8),

                // Text field
                Expanded(
                  child: TextField(
                    controller: controller.textController,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => controller.sendMessage(),
                    decoration: InputDecoration(
                      hintText: 'chat_hint'.tr,
                      hintStyle: TextStyle(
                          color: Colors.grey.shade400, fontSize: 14),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Send
                Obx(() => GestureDetector(
                  onTap: controller.isSending.value
                      ? null
                      : controller.sendMessage,
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: controller.isSending.value
                        ? const Padding(
                      padding: EdgeInsets.all(10),
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                        : const Icon(Icons.send,
                        color: Colors.white, size: 18),
                  ),
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}