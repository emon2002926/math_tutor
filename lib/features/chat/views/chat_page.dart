import 'package:flutter/material.dart';
import 'package:flutter_project/features/chat/views/chat_drawer.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/util/screen_size.dart';
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
        backgroundColor: Colors.white,
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
    final isTablet = context.isTabletDevice;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.auto_awesome,
                  size: context.sp(10), color: Colors.blue.shade200),
              SizedBox(width: context.w(40)),
              Icon(Icons.auto_awesome,
                  size: context.sp(14), color: Colors.yellow.shade400),
              SizedBox(width: context.w(20)),
              Icon(Icons.auto_awesome,
                  size: context.sp(8), color: Colors.pink.shade200),
            ],
          ),

          SizedBox(height: context.h(24)),

          AppText(
            data: 'chat_empty_title'.tr,
            fontSize: isTablet ? 20 : 24,
            fontWeight: FontWeight.bold,
            googleFontFamily: GoogleFonts.montserrat,
          ),

          SizedBox(height: context.h(24)),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.auto_awesome,
                  size: context.sp(8), color: Colors.purple.shade200),
              SizedBox(width: context.w(20)),
              Icon(Icons.auto_awesome,
                  size: context.sp(22), color: Colors.yellow.shade400),
              SizedBox(width: context.w(10)),
              Icon(Icons.auto_awesome,
                  size: context.sp(10), color: Colors.blue.shade300),
              SizedBox(width: context.w(30)),
              Icon(Icons.auto_awesome,
                  size: context.sp(8), color: Colors.orange.shade200),
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
        padding: EdgeInsets.symmetric(
            horizontal: context.w(16), vertical: context.h(12)),
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

// ── Chat Input Bar ─────────────────────────────────────────────────────────
class _ChatInputBar extends StatelessWidget {
  final ChatController controller;
  const _ChatInputBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    final iconSize  = context.w(38);
    final btnRadius = context.w(25);

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: context.w(12), vertical: context.h(8)),
      decoration: const BoxDecoration(color: Color(0xFF1F2A44)),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            // ── Image preview ──────────────────────────────────────────
            Obx(() {
              if (controller.selectedImage.value == null) {
                return const SizedBox.shrink();
              }
              final file = controller.selectedImage.value!;
              return Padding(
                padding: EdgeInsets.only(bottom: context.h(10)),
                child: Row(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        GestureDetector(
                          onTap: () =>
                              FullImagePreview.open(false,context, file: file),
                          child: Container(
                            width: context.w(72),
                            height: context.w(72),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(context.w(14)),
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
                              borderRadius:
                              BorderRadius.circular(context.w(13)),
                              child: Image.file(file, fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        Positioned(
                          top: -6,
                          right: -6,
                          child: GestureDetector(
                            onTap: controller.removeImage,
                            child: Container(
                              width: context.w(22),
                              height: context.w(22),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade800,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Icon(Icons.close,
                                  color: Colors.white,
                                  size: context.sp(13)),
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
                margin: EdgeInsets.only(bottom: context.h(6)),
                padding: EdgeInsets.symmetric(
                    horizontal: context.w(12), vertical: context.h(6)),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(context.w(12)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.audiotrack,
                        color: Colors.white, size: context.sp(18)),
                    SizedBox(width: context.w(8)),
                    Expanded(
                      child: AppText(
                        data: 'audio_ready'.tr,
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                    GestureDetector(
                      onTap: controller.removeAudio,
                      child: Icon(Icons.close,
                          color: Colors.white70, size: context.sp(18)),
                    ),
                  ],
                ),
              );
            }),

            // ── Main input row ─────────────────────────────────────────
            Row(
              children: [

                // ── Mic ──
                Obx(() => GestureDetector(
                  onTap: controller.toggleRecording,
                  child: Container(
                    width: iconSize,
                    height: iconSize,
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
                      size: context.sp(22),
                    ),
                  ),
                )),

                // ── Image picker ──
                GestureDetector(
                  onTap: controller.pickImage,
                  child: Container(
                    width: iconSize,
                    height: iconSize,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.image_outlined,
                        color: Colors.white, size: context.sp(20)),
                  ),
                ),

                SizedBox(width: context.w(8)),

                // ── Text field ──
                Expanded(
                  child: TextField(
                    controller: controller.textController,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => controller.sendMessage(),
                    style: TextStyle(color:Colors.black87,fontSize: context.sp(14)),
                    decoration: InputDecoration(
                      hintText: 'chat_hint'.tr,

                      hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: context.sp(14)),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: context.w(16),
                          vertical: context.h(10)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(btnRadius),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(btnRadius),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(btnRadius),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                SizedBox(width: context.w(8)),

                // ── Send ──
                Obx(() => GestureDetector(
                  onTap: controller.isSending.value
                      ? null
                      : controller.sendMessage,
                  child: Container(
                    width: iconSize,
                    height: iconSize,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: controller.isSending.value
                        ? Padding(
                      padding: EdgeInsets.all(context.w(10)),
                      child: const CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                        : Icon(Icons.send,
                        color: Colors.white, size: context.sp(18)),
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