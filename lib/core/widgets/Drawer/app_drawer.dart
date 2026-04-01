//
// import 'package:anjapepito/core/constants/app_assert_image.dart';
// import 'package:anjapepito/features/onboarding/views/onboarding_screen.dart';
// import 'package:anjapepito/features/profile/views/profile_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../constants/app_assert_image.dart';
// import '../../util/app_navigation.dart';
// import '../../util/screen_size.dart';
// import '../../util/storage_service.dart';
// import '../text/app_text.dart';
// import 'package:anjapepito/features/profile/views/terms_page.dart';
// class CustomAppDrawer extends StatelessWidget {
//   const CustomAppDrawer({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       backgroundColor: const Color(0xFFF9F5ED),
//       child: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Menu icon
//             Padding(
//               padding: EdgeInsets.all(context.responsiveSize(20)),
//               child: GestureDetector(
//                 onTap: () => Navigator.pop(context),
//                 child: Image.asset(
//                   AppAssertImage.instance.drawerIcon,
//                   height: context.responsiveSize(28),
//                   width: context.responsiveSize(28),
//                   color: const Color(0xFF2D2D2D),
//                 ),
//               ),
//             ),
//
//             Container(height: 1, color: const Color(0xFFE8E4DC)),
//
//             SizedBox(height: context.responsiveSize(8)),
//
//             // Profile
//             _buildDrawerItem(
//               context,
//               title: 'Profile',
//               onTap: () {
//                 Navigator.pop(context);
//                 AppNavigation.push( const ProfileScreen());
//               },
//             ),
//
//             Padding(
//               padding: EdgeInsets.symmetric(
//                 horizontal: context.responsiveSize(20),
//               ),
//               child: Container(height: 1, color: const Color(0xFFE8E4DC)),
//             ),
//
//             // Terms and condition
//             _buildDrawerItem(
//               context,
//               title: 'Terms and condition',
//               onTap: () {
//                 Navigator.pop(context);
//                 AppNavigation.push( const TermsPage());
//               },
//             ),
//
//             Padding(
//               padding: EdgeInsets.symmetric(
//                 horizontal: context.responsiveSize(20),
//               ),
//               child: Container(height: 1, color: const Color(0xFFE8E4DC)),
//             ),
//
//             const Spacer(),
//
//             // Log out
//             Padding(
//               padding: EdgeInsets.all(context.responsiveSize(20)),
//               child: GestureDetector(
//                 onTap: () {
//                   Navigator.pop(context);
//                   _handleLogout(context);
//                 },
//                 child: Container(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: context.responsiveSize(20),
//                     vertical: context.responsiveSize(12),
//                   ),
//                   decoration: BoxDecoration(
//                     color: Color(0xFFFBE9D3),
//                     borderRadius: BorderRadius.circular(
//                       context.responsiveSize(12),
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.4),
//                         blurRadius: 10,
//                         offset: const Offset(0, 2),
//                       ),
//                     ]
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Image.asset(
//                         AppAssertImage.instance.logOutIcon,
//                         height: context.responsiveSize(20),
//                         width: context.responsiveSize(20),
//                         color: const Color(0xFF624D40),
//                       ),
//                       SizedBox(width: context.responsiveSize(8)),
//                       AppText(
//                         data: 'Log out',
//                         fontSize: 15,
//                         fontWeight: FontWeight.bold,
//                         color: const Color(0xFF624D40),
//                         useResponsiveFontSize: true,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//
//             SizedBox(height: context.responsiveSize(16)),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDrawerItem(
//       BuildContext context, {
//         required String title,
//         required VoidCallback onTap,
//       }) {
//     return GestureDetector(
//       onTap: onTap,
//       behavior: HitTestBehavior.opaque,
//       child: Padding(
//         padding: EdgeInsets.symmetric(
//           horizontal: context.responsiveSize(20),
//           vertical: context.responsiveSize(16),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             AppText(
//               data: title,
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: const Color(0xFF2D2D2D),
//               useResponsiveFontSize: true,
//             ),
//             Icon(
//               Icons.chevron_right,
//               size: context.responsiveSize(24),
//               color: const Color(0xFF2D2D2D),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _handleLogout(BuildContext context) {
//     StorageService.clearToken();
//     // AppNavigation.pushAndClear(context, const SignInScreen());
//     Get.offAll(OnboardingScreen());
//   }
// }