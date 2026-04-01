import 'package:flutter/material.dart';
import 'package:flutter_project/features/mainscreen/widgets/chat_drawer.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:io';
import '../../../core/widgets/text/app_text.dart';
import '../../../core/widgets/text/math_text.dart';
import '../controllers/chat_controller.dart';
import '../models/chat_message.dart';

// ── Full-screen image preview helper ──────────────────────────────────────
void _openFullImagePreview(BuildContext context,
    {File? file, String? url}) {
  assert(file != null || url != null);
  showDialog(
    context: context,
    barrierColor: Colors.black87,
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        children: [
          Center(
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 5.0,
              child: file != null
                  ? Image.file(file)
                  : Image.network(url!),
            ),
          ),
          Positioned(
            top: 48,
            right: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close,
                    color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

// ── ChatPage ───────────────────────────────────────────────────────────────
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
              ? _UserBubble(message: msg)
              : _AiBubble(message: msg);
        },
      );
    });
  }
}

// ── User Bubble ────────────────────────────────────────────────────────────
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

                // ── Image (tappable → full preview) ──
                if (message.localImagePath != null ||
                    message.imageUrl != null) ...[
                  GestureDetector(
                    onTap: () => _openFullImagePreview(
                      context,
                      file: message.localImagePath != null
                          ? File(message.localImagePath!)
                          : null,
                      url: message.imageUrl,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: message.localImagePath != null
                          ? Image.file(
                        File(message.localImagePath!),
                        width: 180,
                        height: 180,
                        fit: BoxFit.cover,
                      )
                          : Image.network(
                        message.imageUrl!,
                        width: 180,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                ],

                // ── Audio ──
                if (message.localAudioPath != null ||
                    message.audioUrl != null) ...[
                  _AudioBubble(
                    localPath: message.localAudioPath,
                    remoteUrl: message.audioUrl,
                  ),
                  const SizedBox(height: 4),
                ],

                // ── Text ──
                if (message.message.isNotEmpty)
                  Container(
                    constraints: BoxConstraints(
                        maxWidth:
                        MediaQuery.of(context).size.width * 0.72),
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
                    child: AppText(
                      data: message.message,
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Audio Bubble ───────────────────────────────────────────────────────────
class _AudioBubble extends StatefulWidget {
  final String? localPath;
  final String? remoteUrl;
  const _AudioBubble({this.localPath, this.remoteUrl});

  @override
  State<_AudioBubble> createState() => _AudioBubbleState();
}

class _AudioBubbleState extends State<_AudioBubble> {
  late final AudioPlayer _player;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _initAudio();

    _player.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state.playing &&
              state.processingState != ProcessingState.completed;
        });
      }
    });

    _player.durationStream
        .listen((d) {
      if (mounted) setState(() => _duration = d ?? Duration.zero);
    });

    _player.positionStream
        .listen((p) {
      if (mounted) setState(() => _position = p);
    });
  }

  Future<void> _initAudio() async {
    try {
      if (widget.localPath != null) {
        await _player.setFilePath(widget.localPath!);
      } else if (widget.remoteUrl != null) {
        final url = widget.remoteUrl!.startsWith('http')
            ? widget.remoteUrl!
            : 'https://mathapi.dsrt321.online${widget.remoteUrl}';
        await _player.setUrl(url);
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final progress = _duration.inMilliseconds > 0
        ? _position.inMilliseconds / _duration.inMilliseconds
        : 0.0;

    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2A44),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () async {
              if (_isPlaying) {
                await _player.pause();
              } else {
                if (_player.processingState ==
                    ProcessingState.completed) {
                  await _player.seek(Duration.zero);
                }
                await _player.play();
              }
            },
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: const Color(0xFF1F2A44),
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.white),
                    minHeight: 3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_fmt(_position)} / ${_fmt(_duration)}',
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── AI Bubble ──────────────────────────────────────────────────────────────
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
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 12),
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
                : MathText(
              data: message.message,
              color: Colors.black87,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Typing Indicator ───────────────────────────────────────────────────────
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
      Future.delayed(
        Duration(milliseconds: i * 160),
            () => _controllers[i].repeat(reverse: true),
      );
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

// ── Chat Input Bar ─────────────────────────────────────────────────────────
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
                          onTap: () => _openFullImagePreview(context, file: file),
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