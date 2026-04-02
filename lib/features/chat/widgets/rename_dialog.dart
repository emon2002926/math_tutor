import 'package:flutter/material.dart';
import 'package:flutter_project/core/widgets/text/app_text.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import '../../../core/util/screen_size.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/text/text_field/AppTextFiled.dart';

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
    final isTablet = context.isTabletDevice;

    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.w(20))),
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isTablet
            ? context.screenWidth * 0.25
            : context.w(24),
        vertical: context.h(40),
      ),
      child: Padding(
        padding: EdgeInsets.all(context.w(24)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Title ──────────────────────────────
            Row(
              children: [
                Container(
                  width: context.w(38),
                  height: context.w(38),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F2A44).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(context.w(10)),
                  ),
                  child: Icon(
                    Icons.edit_outlined,
                    color: const Color(0xFF1F2A44),
                    size: context.sp(18),
                  ),
                ),
                SizedBox(width: context.w(12)),
                AppText(
                  data: 'rename_chat'.tr,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1F2A44),
                ),
              ],
            ),

            SizedBox(height: context.h(20)),

            // ── Text field ─────────────────────────
            AppTextField(
              hintText: 'enter_new_name'.tr,
              controller: _controller,
              focusedErrorBorderColor: const Color(0xFF1F2A44),
              prefixIcon: Icons.edit_outlined,
            ),

            SizedBox(height: context.h(24)),

            // ── Actions ────────────────────────────
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    buttonText: 'cancel'.tr,
                    onPressed: () => Navigator.pop(context),
                    fillColor: Colors.transparent,
                    borderColor: Colors.grey.shade300,
                    borderWidth: 1,
                    textColor: Colors.grey.shade600,
                    borderRadius: 12,
                    buttonHeight: 48,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: context.w(12)),
                Expanded(
                  child: AppButton(
                    buttonText: 'save'.tr,
                    onPressed: () {
                      final newTitle = _controller.text.trim();
                      if (newTitle.isNotEmpty &&
                          newTitle != widget.currentTitle) {
                        widget.onSave(newTitle);
                      }
                    },
                    fillColor: const Color(0xFF1F2A44),
                    borderRadius: 12,
                    buttonHeight: 48,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
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