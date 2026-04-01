// lib/utils/size_config.dart
import 'dart:math';

import 'package:flutter/material.dart';

extension ScreenSize on BuildContext {
  // ─── Designer's Figma frame (ask your designer, commonly 375 or 390) ───
  static const double _designWidth = 393.0;
  static const double _designHeight = 852.0;

  // ─── Raw screen info ────────────────────────────────────────────────────
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  // ─── Scale factors ──────────────────────────────────────────────────────
  double get _scaleWidth => screenWidth / _designWidth;
  double get _scaleHeight => screenHeight / _designHeight;

  // For text: use the smaller axis so text doesn't balloon on tablets
  double get _scaleText => min(_scaleWidth, _scaleHeight);

  // ─── Core converters (replace all your old usages with these) ───────────

  /// Width-based scaling — use for horizontal sizes, padding, widths
  double w(double px) => px * _scaleWidth;

  /// Height-based scaling — use for vertical sizes, heights
  double h(double px) => px * _scaleHeight;

  /// Font size scaling — matches Figma px directly
  double sp(double px) => px * _scaleText;

  // ─── Responsive helpers (kept for backward compat) ──────────────────────
  double widthPercentage(double percentage) => screenWidth * (percentage / 100);
  double heightPercentage(double percentage) => screenHeight * (percentage / 100);

  /// @deprecated — use sp() instead
  double responsiveSize(double size) => sp(size);

  /// @deprecated — use sp() instead
  double responsiveFontSize(double size) => sp(size);

  // ─── Spacing (now properly scaled) ──────────────────────────────────────
  double get spacing4  => w(4);
  double get spacing8  => w(8);
  double get spacing12 => w(12);
  double get spacing16 => w(16);
  double get spacing24 => w(24);
  double get spacing32 => w(32);

  // ─── Card dimensions (kept exactly as before) ───────────────────────────
  double get cardWidth  => screenWidth * 0.25;
  double get cardHeight => cardWidth * 1.5;
}