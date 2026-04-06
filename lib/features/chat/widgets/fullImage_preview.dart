import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/util/screen_size.dart';
import '../../../core/widgets/text/app_text.dart';


class FullImagePreview {
  static void open(BuildContext context, {File? file, String? url}) {
    assert(file != null || url != null);
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [

              // ── Zoomable image ────────────────────────────────────
              InteractiveViewer(
                minScale: 0.5,
                maxScale: 8.0,
                constrained: false,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.w(8),
                      vertical: context.h(16),
                    ),
                    child: file != null
                        ? Image.file(
                      file,
                      fit: BoxFit.contain,
                      width: context.screenWidth,
                    )
                        : Image.network(
                      url!,
                      fit: BoxFit.contain,
                      width: context.screenWidth,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return SizedBox(
                          width: context.screenWidth,
                          height: context.h(200),
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                              value: progress.expectedTotalBytes != null
                                  ? progress.cumulativeBytesLoaded /
                                  progress.expectedTotalBytes!
                                  : null,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (_, __, ___) => Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.broken_image_outlined,
                                color: Colors.white54,
                                size: context.sp(48)),
                            SizedBox(height: context.h(12)),
                            AppText(
                              data: 'Failed to load image',
                              color: Colors.white54,
                              fontSize: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // ── Close button ──────────────────────────────────────
              Positioned(
                top: context.h(12),
                right: context.w(16),
                child: GestureDetector(
                  onTap: () => Navigator.pop(ctx),
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
      ),
    );
  }
}