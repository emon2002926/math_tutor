// import 'package:flutter/material.dart';
// import 'dart:ui';
// import '../app_text.dart';
// import '../utils/screen_size.dart';
//
// class BuildAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final String? title;
//   final String? subtitle; // Subtitle displayed below the title
//   final Color? subtitleColor;
//   final double? subtitleSize;
//   final FontWeight? subtitleFontWeight;
//   final Color? titleColor;
//   final Color? iconColor;
//   final bool enableFrostEffect;
//   final bool showSideButton;
//   final VoidCallback? onSideButtonPressed;
//   final IconData sideButtonIcon;
//   final bool showBackButton;
//   final Color? backgroundColor;
//   final double? titleSize;
//   final FontWeight? fontWeight;
//   final VoidCallback? onBackButtonPressed;
//   final bool useCircularBackButton;
//   final Color? circularButtonColor;
//   final double? circularButtonSize;
//   final IconData backButtonIcon;
//   final bool useMinimalStyle; // Enables the minimal chevron-left row layout
//
//   const BuildAppBar({
//     super.key,
//     this.title,
//     this.subtitle,
//     this.subtitleColor,
//     this.subtitleSize,
//     this.subtitleFontWeight,
//     this.titleColor,
//     this.iconColor,
//     this.enableFrostEffect = false,
//     this.showSideButton = false,
//     this.onSideButtonPressed,
//     this.sideButtonIcon = Icons.more_vert,
//     this.showBackButton = true,
//     this.backgroundColor,
//     this.titleSize,
//     this.fontWeight,
//     this.onBackButtonPressed,
//     this.useCircularBackButton = false,
//     this.circularButtonColor,
//     this.circularButtonSize,
//     this.backButtonIcon = Icons.arrow_back,
//     this.useMinimalStyle = false,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     // ── Minimal style (matches _buildAppBar) ──────────────────────────────────
//     if (useMinimalStyle) {
//       return Container(
//         color: backgroundColor ?? Colors.transparent,
//         child: Padding(
//           padding: EdgeInsets.symmetric(
//             horizontal: context.responsiveSize(20),
//             vertical: context.responsiveSize(12),
//           ),
//           child: Row(
//             children: [
//               // Back button — chevron_left icon
//               showBackButton
//                   ? GestureDetector(
//                 onTap: onBackButtonPressed ?? () => Navigator.pop(context),
//                 child: Icon(
//                   Icons.chevron_left,
//                   size: context.responsiveSize(28),
//                   color: iconColor ?? const Color(0xFF2D2D2D),
//                 ),
//               )
//                   : SizedBox(width: context.responsiveSize(28)),
//
//               // Centered title + optional subtitle
//               Expanded(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     if (title != null)
//                       AppText(
//                         data: title!,
//                         fontSize: titleSize ?? 17,
//                         fontWeight: fontWeight ?? FontWeight.w600,
//                         color: titleColor ?? const Color(0xFF2D2D2D),
//                         useResponsiveFontSize: true,
//                         textAlign: TextAlign.center,
//                       ),
//                     if (subtitle != null)
//                       AppText(
//                         data: subtitle!,
//                         fontSize: subtitleSize ?? 13,
//                         fontWeight: subtitleFontWeight ?? FontWeight.w400,
//                         color: subtitleColor ?? const Color(0xFFB0B0B0),
//                         useResponsiveFontSize: true,
//                         textAlign: TextAlign.center,
//                       ),
//                   ],
//                 ),
//               ),
//
//               // Balancing spacer — keeps title truly centered,
//               // or a side action button when showSideButton is true
//               showSideButton
//                   ? GestureDetector(
//                 onTap: onSideButtonPressed,
//                 child: Icon(
//                   sideButtonIcon,
//                   size: context.responsiveSize(28),
//                   color: iconColor ?? const Color(0xFF2D2D2D),
//                 ),
//               )
//                   : SizedBox(width: context.responsiveSize(28)),
//             ],
//           ),
//         ),
//       );
//     }
//
//     // ── Original style (unchanged) ────────────────────────────────────────────
//
//     Widget buildCircularBackButton() {
//       final size = circularButtonSize ?? context.responsiveSize(50);
//       final color = circularButtonColor ?? const Color(0xFF0047AB);
//
//       return Padding(
//         padding: EdgeInsets.only(
//           left: context.responsiveSize(16),
//           top: context.responsiveSize(8),
//           bottom: context.responsiveSize(8),
//         ),
//         child: GestureDetector(
//           onTap: onBackButtonPressed ?? () { Navigator.pop(context); },
//           child: Container(
//             width: size,
//             height: size,
//             decoration: BoxDecoration(
//               color: color,
//               shape: BoxShape.circle,
//               boxShadow: [
//                 BoxShadow(
//                   color: color.withOpacity(0.3),
//                   blurRadius: 8,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Center(
//               child: Icon(
//                 backButtonIcon,
//                 color: iconColor ?? Colors.black,
//                 size: context.responsiveSize(24),
//               ),
//             ),
//           ),
//         ),
//       );
//     }
//
//     Widget buildStandardBackButton() {
//       return IconButton(
//         icon: Icon(backButtonIcon, color: iconColor ?? Colors.black),
//         onPressed: onBackButtonPressed ?? () { Navigator.pop(context); },
//       );
//     }
//
//     final appBarContent = AppBar(
//       backgroundColor: backgroundColor ??
//           (enableFrostEffect
//               ? Colors.white.withOpacity(0.15)
//               : Colors.transparent),
//       elevation: 0,
//       automaticallyImplyLeading: false,
//       leading: showBackButton
//           ? (useCircularBackButton
//           ? buildCircularBackButton()
//           : buildStandardBackButton())
//           : null,
//       leadingWidth: useCircularBackButton
//           ? context.responsiveSize(74)
//           : null,
//       title: title != null
//           ? Text(
//         title!,
//         style: TextStyle(
//           color: titleColor ?? Colors.white,
//           fontSize: titleSize ?? 24,
//           fontWeight: fontWeight ?? FontWeight.normal,
//         ),
//       )
//           : null,
//       centerTitle: true,
//       actions: showSideButton
//           ? [
//         IconButton(
//           icon: Icon(sideButtonIcon, color: iconColor ?? Colors.white),
//           onPressed: onSideButtonPressed,
//           iconSize: 24,
//         )
//       ]
//           : null,
//     );
//
//     return enableFrostEffect
//         ? ClipRRect(
//       borderRadius: const BorderRadius.only(
//         bottomLeft: Radius.circular(12),
//         bottomRight: Radius.circular(12),
//       ),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//         child: Container(
//           color: backgroundColor?.withOpacity(0.2) ?? Colors.transparent,
//           child: appBarContent,
//         ),
//       ),
//     )
//         : appBarContent;
//   }
//
//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }