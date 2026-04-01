
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_project/features/chat/widgets/fullImage_preview.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/widgets/text/math_text.dart';
import '../models/chat_message.dart';
import 'audio_bubble.dart';






import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_project/features/chat/widgets/fullImage_preview.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/widgets/text/math_text.dart';
import '../models/chat_message.dart';
import 'audio_bubble.dart';

class UserBubble extends StatelessWidget {
  final ChatMessage message;
  const UserBubble({super.key, required this.message});

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

                // ── Image ──
                if (message.localImagePath != null || message.imageUrl != null) ...[
                  GestureDetector(
                    onTap: () => FullImagePreview.open(
                      context,
                      file: message.localImagePath != null
                          ? File(message.localImagePath!)
                          : null,
                      url: message.imageUrl,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: message.localImagePath != null
                          ? _LocalImageWithLoader(path: message.localImagePath!)
                          : _NetworkImageWithLoader(url: message.imageUrl!),
                    ),
                  ),
                  const SizedBox(height: 4),
                ],

                // ── Audio ──
                if (message.localAudioPath != null || message.audioUrl != null) ...[
                  AudioBubble(
                    localPath: message.localAudioPath,
                    remoteUrl: message.audioUrl,
                  ),
                  const SizedBox(height: 4),
                ],

                // ── Text ──
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
                    child: SelectionArea(
                      child: MathText(
                        data: message.message,
                        color: Colors.white,
                        fontSize: 15,
                        googleFontFamily: GoogleFonts.montserrat,
                        fontWeight: FontWeight.w500,
                      ),
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

// ── Local image with frame-based loader ────────────────────────────────────
class _LocalImageWithLoader extends StatelessWidget {
  final String path;
  const _LocalImageWithLoader({required this.path});

  @override
  Widget build(BuildContext context) {
    return Image.file(
      File(path),
      width: 180,
      height: 180,
      fit: BoxFit.cover,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) return child;
        return const _ImageLoadingPlaceholder();
      },
    );
  }
}

// ── Network image with progress loader ─────────────────────────────────────
class _NetworkImageWithLoader extends StatelessWidget {
  final String url;
  const _NetworkImageWithLoader({required this.url});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      width: 180,
      height: 180,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        final total = loadingProgress.expectedTotalBytes;
        final loaded = loadingProgress.cumulativeBytesLoaded;
        return _ImageLoadingPlaceholder(
          progress: total != null ? loaded / total : null,
        );
      },
      errorBuilder: (_, __, ___) => const _ImageErrorPlaceholder(),
    );
  }
}

// ── Circular loading placeholder ────────────────────────────────────────────
class _ImageLoadingPlaceholder extends StatelessWidget {
  final double? progress;
  const _ImageLoadingPlaceholder({this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        color: const Color(0xFF1F2A44).withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: SizedBox(
          width: 36,
          height: 36,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: 3,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(
              const Color(0xFF1F2A44).withOpacity(0.55),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Error placeholder ───────────────────────────────────────────────────────
class _ImageErrorPlaceholder extends StatelessWidget {
  const _ImageErrorPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image_outlined,
              color: Colors.grey.shade400, size: 32),
          const SizedBox(height: 6),
          Text(
            'Failed to load',
            style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
          ),
        ],
      ),
    );
  }
}