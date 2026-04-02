import 'package:flutter/material.dart';
import '../../util/screen_size.dart';
import '../text/app_text.dart';

class AppDialog extends StatelessWidget {
  final String? title;
  final String? description;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const AppDialog({
    super.key,
    required this.onConfirm,
    required this.onCancel,
    this.title,
    this.description,
    this.confirmText,
    this.cancelText,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.w(20))),
      backgroundColor: Colors.white,
      // ── Constrain width on tablet ──────────────────────────────────────
      insetPadding: EdgeInsets.symmetric(
        horizontal: context.isTabletDevice
            ? context.screenWidth * 0.25  // 50% of screen on tablet
            : context.w(24),
        vertical: context.h(40),
      ),
      child: Padding(
        padding: EdgeInsets.all(context.w(24)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Title ──────────────────────────────────────────────────────
            AppText(
              data: title ?? 'Confirm',
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1F2A44),
            ),

            SizedBox(height: context.h(10)),

            // ── Description ────────────────────────────────────────────────
            AppText(
              data: description ?? 'Are you sure?',
              fontSize: 14,
              color: Colors.grey.shade600,
            ),

            SizedBox(height: context.h(24)),

            // ── Actions ────────────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: context.h(13)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(context.w(12))),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    child: AppText(
                      data: cancelText ?? 'Cancel',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
                SizedBox(width: context.w(12)),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1F2A44),
                      padding: EdgeInsets.symmetric(vertical: context.h(13)),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(context.w(12))),
                    ),
                    child: AppText(
                      data: confirmText ?? 'Confirm',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}