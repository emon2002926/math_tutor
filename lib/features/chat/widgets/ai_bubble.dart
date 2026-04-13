import 'package:flutter/material.dart';
import 'package:flutter_project/features/chat/widgets/typing_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/util/screen_size.dart';
import '../../../core/widgets/text/app_text.dart';
import '../../../core/widgets/text/math_text.dart';
import '../models/chat_message.dart';
import 'fullImage_preview.dart';

class AiBubble extends StatelessWidget {
  final ChatMessage message;
  const AiBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.h(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width *
                    (context.isTabletDevice ? 0.65 : 0.78)),
            padding: EdgeInsets.symmetric(
                horizontal: context.w(16), vertical: context.h(12)),
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
                ? const TypingIndicator()
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [

                // ── Wolfram image ──────────────────────────────
                if (message.wolframImage != null) ...[
                  GestureDetector(
                    onTap: () => FullImagePreview.open(false,
                      context,
                      url: message.wolframImage,
                      // url:  "https://mathapi.dsrt321.online/media/chat_images/shape_55f304ffce0b4849b6059d7db6680f32.png",
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(context.w(12)),
                      child: Image.network(
                        // "https://mathapi.dsrt321.online/media/chat_images/shape_55f304ffce0b4849b6059d7db6680f32.png",
                        "${message.wolframImage!}",
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Container(
                            width: double.infinity,
                            height: context.h(160),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius:
                              BorderRadius.circular(context.w(12)),
                            ),
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                value: progress.expectedTotalBytes != null
                                    ? progress.cumulativeBytesLoaded /
                                    progress.expectedTotalBytes!
                                    : null,
                                color: const Color(0xFF1F2A44),
                              ),
                            ),
                          );
                        },
                        errorBuilder: (_, __, ___) => Container(
                          padding: EdgeInsets.all(context.w(12)),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius:
                            BorderRadius.circular(context.w(12)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.broken_image_outlined,
                                  color: Colors.grey.shade400,
                                  size: context.sp(20)),
                              SizedBox(width: context.w(8)),
                              AppText(
                                data: 'Failed to load image',
                                fontSize: 12,
                                color: Colors.grey.shade500,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: context.h(8)),
                ],

                // ── Text (only if non-empty and not just the markdown image syntax) ──
                if (message.message.isNotEmpty)
                  MathText(
                    data: message.message,
                    color: Colors.black87,
                    fontSize: 15,
                    googleFontFamily: GoogleFonts.montserrat,
                    fontWeight: FontWeight.w500,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Strip the markdown image syntax the API embeds in the message text
  // e.g. "Final Answer: ![Mathematical Visualization](http://...)"
  // String _cleanMessage(String text) {
  //   return text
  //       .replaceAll(RegExp(r'!\[.*?\]\(.*?\)'), '')
  //       .trim();
  // }
}