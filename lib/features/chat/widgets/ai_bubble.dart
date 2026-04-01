import 'package:flutter/material.dart';
import 'package:flutter_project/features/chat/widgets/typing_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/widgets/text/math_text.dart';
import '../models/chat_message.dart';

class AiBubble extends StatelessWidget {
  final ChatMessage message;
  const AiBubble({super.key, required this.message});

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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                : SelectionArea(
              child: MathText(
                data: message.message,
                color: Colors.black87,
                fontSize: 15,
                googleFontFamily: GoogleFonts.montserrat,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}