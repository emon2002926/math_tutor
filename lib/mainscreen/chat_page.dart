import 'package:flutter/material.dart';
import 'package:flutter_project/core/app_text.dart';
import 'package:flutter_project/mainscreen/controllers/chat_controller.dart';
import 'package:flutter_project/mainscreen/widgets/chat_drawer.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'models/chat_message.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});
  @override
  Widget build(BuildContext context) {
    final ChatController controller = Get.put(ChatController());

    return Scaffold(
      backgroundColor: Colors.white,
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

      body: Obx(() => controller.messages.isEmpty
          ? const _EmptyState()
          : _MessageList(controller: controller)),

      bottomNavigationBar: Builder(
        builder: (ctx) => Padding(
          padding:
          EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: _ChatInputBar(controller: controller),
        ),
      ),

      resizeToAvoidBottomInset: true,
    );
  }
}

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
              Icon(Icons.auto_awesome, size: 14, color: Colors.yellow.shade400),
              const SizedBox(width: 20),
              Icon(Icons.auto_awesome, size: 8, color: Colors.pink.shade200),
            ],
          ),
          const SizedBox(height: 24),
          const AppText(
              data: "What can I help with ?", fontSize: 22, fontWeight: FontWeight.bold),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.auto_awesome, size: 8, color: Colors.purple.shade200),
              const SizedBox(width: 20),
              Icon(Icons.auto_awesome, size: 22, color: Colors.yellow.shade400),
              const SizedBox(width: 10),
              Icon(Icons.auto_awesome, size: 10, color: Colors.blue.shade300),
              const SizedBox(width: 30),
              Icon(Icons.auto_awesome, size: 8, color: Colors.orange.shade200),
            ],
          ),
        ],
      ),
    );
  }
}

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
    // Auto-scroll when messages change
    ever(widget.controller.messages, (_) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: msgs.length,
        itemBuilder: (_, i) {
          final msg = msgs[i];
          return msg.sender == MessageSender.user
              ? _UserBubble(message: msg)
              : _AiBubble(message: msg);
        },
      );
    });
  }
}


class _UserBubble extends StatelessWidget {
  final ChatMessage message;
  const _UserBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Image (local or remote)
                if (message.localImagePath != null ||
                    message.imageUrl != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: message.localImagePath != null
                        ? Image.file(File(message.localImagePath!),
                        width: 180, height: 180, fit: BoxFit.cover)
                        : Image.network(message.imageUrl!,
                        width: 180, height: 180, fit: BoxFit.cover),
                  ),
                  const SizedBox(height: 4),
                ],
                // Text
                if (message.message.isNotEmpty)
                  Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.72),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: const BoxDecoration(
                        color: Color(0xFF1F2A44),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(18),
                          topRight: Radius.circular(18),
                          bottomLeft: Radius.circular(18),
                          bottomRight: Radius.circular(4),
                        ),
                      ),
                      child: AppText(data: message.message, color: Colors.white, fontSize: 15)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class _AiBubble extends StatelessWidget {
  final ChatMessage message;
  const _AiBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.78),
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
              ),
              child: message.isLoading
                  ? const _TypingIndicator()
                  : AppText(data: message.message, color: Colors.black87, fontSize: 15)),

        ],
      ),
    );
  }
}


class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      3,
          (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      ),
    );
    for (int i = 0; i < 3; i++) {
      Future.delayed(Duration(milliseconds: i * 160),
              () => _controllers[i].repeat(reverse: true));
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _controllers[i],
          builder: (_, __) => Transform.translate(
            offset: Offset(0, -6 * _controllers[i].value),
            child: Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: Colors.grey.shade500,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      }),
    );
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
        child: Row(
          children: [
            // Mic
            IconButton(
              icon: const Icon(Icons.mic, color: Colors.white),
              onPressed: () {},
            ),

            // Image picker
            Obx(() => GestureDetector(
              onTap: controller.pickImage,
              onLongPress: controller.removeImage,
              child: Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: controller.selectedImage.value != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    controller.selectedImage.value!,
                    fit: BoxFit.cover,
                  ),
                )
                    : const Icon(Icons.image,
                    color: Colors.grey, size: 20),
              ),
            )),

            const SizedBox(width: 8),

            // Text field
            Expanded(
              child: TextField(
                controller: controller.textController,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => controller.sendMessage(),
                decoration: InputDecoration(
                  hintText: "Ask anything",
                  hintStyle:
                  TextStyle(color: Colors.grey.shade400, fontSize: 14),
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
      ),
    );
  }
}
