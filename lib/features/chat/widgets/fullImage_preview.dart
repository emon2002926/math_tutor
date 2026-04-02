import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/util/screen_size.dart';


class FullImagePreview {
  static void open(BuildContext context, {File? file, String? url}) {
    assert(file != null || url != null);
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 5.0,
                child: file != null
                    ? Image.file(file)
                    : Image.network(url!),
              ),
            ),
            Positioned(
              top: context.h(48),
              right: context.w(16),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: context.w(36),
                  height: context.w(36),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close,
                      color: Colors.white, size: context.sp(20)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}