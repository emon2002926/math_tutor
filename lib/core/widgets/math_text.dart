import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class MathText extends StatelessWidget {
  final String data;
  final Color color;
  final double fontSize;

  const MathText({
    super.key,
    required this.data,
    this.color = Colors.black87,
    this.fontSize = 15,
  });

  @override
  Widget build(BuildContext context) {
    final spans = _buildSpans(data);
    return RichText(
      text: TextSpan(children: spans),
    );
  }

  List<InlineSpan> _buildSpans(String text) {
    final List<InlineSpan> spans = [];

    // Matches \(...\) for inline math and \[...\] for block math
    final regex = RegExp(r'\\\((.+?)\\\)|\\\[(.+?)\\\]', dotAll: true);
    int lastEnd = 0;

    for (final match in regex.allMatches(text)) {
      // Plain text before match
      if (match.start > lastEnd) {
        spans.add(TextSpan(
          text: text.substring(lastEnd, match.start),
          style: TextStyle(color: color, fontSize: fontSize),
        ));
      }

      // LaTeX content (group 1 = inline, group 2 = block)
      final latex = match.group(1) ?? match.group(2) ?? '';
      final isBlock = match.group(2) != null;

      spans.add(WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 2,
            vertical: isBlock ? 6 : 0,
          ),
          child: Math.tex(
            latex,
            textStyle: TextStyle(fontSize: fontSize, color: color),
            onErrorFallback: (err) => Text(
              latex,
              style: TextStyle(color: color, fontSize: fontSize),
            ),
          ),
        ),
      ));

      lastEnd = match.end;
    }

    // Remaining plain text
    if (lastEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastEnd),
        style: TextStyle(color: color, fontSize: fontSize),
      ));
    }

    return spans;
  }
}