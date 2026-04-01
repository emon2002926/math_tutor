import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/app_colors.dart';
import '../../../util/screen_size.dart';
import '../app_text.dart';


class AppTextField extends StatefulWidget {
  final String? label;
  final String? label2;
  final String? hintText;
  final TextEditingController? controller;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final FocusNode? focusNode;
  final VoidCallback? suffixIconOnTap;
  final VoidCallback? onSuffixIconTap;
  final Color? borderColor;
  final Color? focusedErrorBorderColor; // 👈 optional custom error highlight color
  final TextInputType? keyboardType;
  final bool enabled;
  final VoidCallback? label2OnClick;
  final Color? fillColor;
  final Color? inputTextColor;
  final Color? hintTextColor;
  final double elevation;
  final Color? shadowColor;
  final BorderRadius? customBorderRadius;
  final bool isHintTextInMiddle;

  const AppTextField({
    super.key,
    this.label,
    this.label2,
    this.label2OnClick,
    this.hintText,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.validator,
    this.focusNode,
    this.suffixIconOnTap,
    this.onSuffixIconTap,
    this.borderColor,
    this.focusedErrorBorderColor,
    this.keyboardType,
    this.enabled = true,
    this.fillColor,
    this.inputTextColor,
    this.hintTextColor,
    this.elevation = 8,
    this.shadowColor,
    this.customBorderRadius,
    this.isHintTextInMiddle = false,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late FocusNode _effectiveFocusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    // Use provided focusNode or create an internal one
    _effectiveFocusNode = widget.focusNode ?? FocusNode();
    _effectiveFocusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() => _isFocused = _effectiveFocusNode.hasFocus);
  }

  @override
  void dispose() {
    _effectiveFocusNode.removeListener(_onFocusChange);
    // Only dispose if we created it internally
    if (widget.focusNode == null) _effectiveFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveSuffixTap = widget.suffixIconOnTap ?? widget.onSuffixIconTap;

    final double inputFontSize     = context.responsiveFontSize(14);
    final double iconSize          = context.responsiveSize(20);
    final double borderRadius      = context.responsiveSize(10);
    final double verticalPadding   = context.responsiveSize(14);
    final double horizontalPadding = context.responsiveSize(16);
    final double spacing           = context.responsiveSize(8);

    final BorderRadius effectiveBorderRadius =
        widget.customBorderRadius ?? BorderRadius.circular(borderRadius);

    // 👇 Determine border color based on focus state
    final Color activeBorderColor = _isFocused
        ? (widget.focusedErrorBorderColor ?? Color(0xFFA68978))
        : (widget.borderColor ?? Colors.transparent);

    final borderSide = BorderSide(color: activeBorderColor, width: _isFocused ? 1.5 : 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                data: widget.label!,
                fontWeight: FontWeight.w600,
                color: _isFocused
                    ? (widget.focusedErrorBorderColor ?? Colors.teal)
                    : AppColors.instance.titleTextColor,
                fontSize: 14,
              ),
              if (widget.label2 != null)
                GestureDetector(
                  onTap: widget.label2OnClick,
                  child: Text(
                    widget.label2!,
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                      fontSize: inputFontSize,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: spacing),
        ],

        Material(
          elevation: widget.elevation,
          shadowColor: widget.shadowColor ?? Colors.black,
          borderRadius: effectiveBorderRadius,
          color: Colors.transparent,
          child: TextFormField(
            controller: widget.controller,
            obscureText: widget.obscureText,
            validator: widget.validator,
            focusNode: _effectiveFocusNode,
            keyboardType: widget.keyboardType,
            enabled: widget.enabled,
            textAlign: widget.isHintTextInMiddle ? TextAlign.center : TextAlign.start,
            style: GoogleFonts.plusJakartaSans(
              color: widget.inputTextColor,
              fontSize: inputFontSize,
            ),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: GoogleFonts.plusJakartaSans(
                color: widget.hintTextColor ?? Colors.grey,
                fontSize: inputFontSize,
                fontWeight: FontWeight.w400,
              ),
              filled: true,
              fillColor: widget.enabled ? widget.fillColor : Colors.grey.shade300,
              prefixIcon: widget.prefixIcon != null
                  ? Icon(widget.prefixIcon, color: _isFocused
                  ? (widget.focusedErrorBorderColor ?? Colors.red) // 👈 icon color changes too
                  : Colors.grey[700], size: iconSize)
                  : null,
              suffixIcon: widget.suffixIcon != null
                  ? GestureDetector(
                onTap: effectiveSuffixTap,
                child: Icon(widget.suffixIcon, color: Color(0xFFA68978), size: iconSize),
              )
                  : null,
              contentPadding: EdgeInsets.symmetric(
                vertical: verticalPadding,
                horizontal: horizontalPadding,
              ),
              border: OutlineInputBorder(borderRadius: effectiveBorderRadius, borderSide: borderSide),
              enabledBorder: OutlineInputBorder(borderRadius: effectiveBorderRadius, borderSide: borderSide),
              focusedBorder: OutlineInputBorder(borderRadius: effectiveBorderRadius, borderSide: borderSide),
            ),
          ),
        ),
      ],
    );
  }
}