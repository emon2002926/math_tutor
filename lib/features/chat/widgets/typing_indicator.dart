
import 'package:flutter/material.dart';

import '../../../core/util/screen_size.dart';
class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
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
            () {
          if (mounted) _controllers[i].repeat(reverse: true);
        },
      );
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dotSize = context.w(8);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _controllers[i],
          builder: (_, __) => Transform.translate(
            offset: Offset(0, -6 * _controllers[i].value),
            child: Container(
              width: dotSize,
              height: dotSize,
              margin: EdgeInsets.symmetric(horizontal: context.w(3)),
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