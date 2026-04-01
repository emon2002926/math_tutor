import 'package:flutter/material.dart';
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Title ──────────────────────────────
            AppText(
              data: title ?? 'Confirm',
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1F2A44),
            ),

            const SizedBox(height: 10),

            // ── Description ────────────────────────
            AppText(
              data: description ?? 'Are you sure?',
              fontSize: 14,
              color: Colors.grey.shade600,
            ),

            const SizedBox(height: 24),

            // ── Actions ────────────────────────────
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
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
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1F2A44),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
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