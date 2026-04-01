import 'package:flutter/material.dart';
import 'package:flutter_project/core/widgets/text/app_text.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class RenameDialog extends StatefulWidget {
  final String currentTitle;
  final ValueChanged<String> onSave;
  const RenameDialog({super.key, required this.currentTitle, required this.onSave});

  @override
  State<RenameDialog> createState() => _RenameDialogState();
}

class _RenameDialogState extends State<RenameDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentTitle);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F2A44).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.edit_outlined,
                    color: Color(0xFF1F2A44),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                AppText(
                  data: 'rename_chat'.tr,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1F2A44),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ── Text field ─────────────────────────
            TextField(
              controller: _controller,
              autofocus: true,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF1F2A44),
              ),
              decoration: InputDecoration(
                hintText: 'enter_new_name'.tr,
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                filled: true,
                fillColor: Colors.grey.shade50,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                      color: Color(0xFF1F2A44), width: 1.5),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Actions ────────────────────────────
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    child: AppText(
                      data: 'cancel'.tr,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final newTitle = _controller.text.trim();
                      if (newTitle.isNotEmpty &&
                          newTitle != widget.currentTitle) {
                        widget.onSave(newTitle);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1F2A44),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: AppText(
                      data: 'save'.tr,
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