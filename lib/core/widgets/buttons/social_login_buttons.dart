import 'package:flutter/material.dart';

import '../../constants/app_assert_image.dart';
import '../../util/screen_size.dart';
import '../text/app_text.dart';
class SocialButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final String? iconPath;
  final IconData? icon;
  final double height;

  const SocialButton({
    super.key,
    required this.onTap,
    required this.text,
    this.iconPath,
    this.icon,
    required this.height,
  }) : assert(
  iconPath != null || icon != null,
  'Provide either iconPath or icon',
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: context.responsiveSize(height),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(context.responsiveSize(28)),
          image: DecorationImage(
            image: AssetImage(AppAssertImage.instance.secoundBrownButtonBg),
            fit: BoxFit.fill,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ── Icon ──
            if (iconPath != null)
              SizedBox(
                width: context.responsiveSize(24),
                height: context.responsiveSize(24),
                child: Image.asset(
                  iconPath!,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Center(
                    child: Text(
                      'G',
                      style: TextStyle(
                        fontSize: context.responsiveSize(18),
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF4285F4),
                      ),
                    ),
                  ),
                ),
              )
            else if (icon != null)
              Icon(
                icon,
                color: const Color(0xFF5C3A00),
                size: context.responsiveSize(24),
              ),

            SizedBox(width: context.responsiveSize(12)),

            // ── Label ──
            AppText(
              data: text,
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF5C3A00),
              useResponsiveFontSize: true,
            ),
          ],
        ),
      ),
    );
  }
}