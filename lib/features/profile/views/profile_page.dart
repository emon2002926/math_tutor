import 'package:flutter/material.dart';
import 'package:flutter_project/features/terms_condition/views/terms_and_condition_page.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../../core/util/screen_size.dart';
import '../../../core/widgets/text/app_text.dart';
import '../../language/controllers/language_controller.dart';
import '../controllers/profileController.dart';


class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    final isTablet = context.isTabletDevice;

    return Scaffold(
      backgroundColor: isTablet ? const Color(0xFFF0F2F5) : Colors.white,
      appBar: AppBar(
        backgroundColor: isTablet ? const Color(0xFFF0F2F5) : Colors.white,
        elevation: isTablet ? 0 : 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Colors.black, size: context.sp(22)),
          onPressed: () => Navigator.pop(context),
        ),
        title: AppText(
          data: 'profile'.tr,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1F2A44),
        ),
        centerTitle: false,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: context.pagePadding,
                vertical: context.h(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── Profile Card ──────────────────────────────────────────
                  _SectionCard(
                    child: Row(
                      children: [
                        Obx(() => _AvatarOrLottie(
                          imageUrl: controller.userImage.value,
                          radius: context.w(isTablet ? 32 : 28),
                        )),

                        SizedBox(width: context.w(14)),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(() => AppText(
                                data: controller.userName.value,
                                fontSize: isTablet ? 17 : 16,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1F2A44),
                              )),
                              SizedBox(height: context.h(3)),
                              Obx(() => AppText(
                                data: controller.userEmail.value,
                                fontSize: isTablet ? 14 : 13,
                                color: Colors.grey.shade500,
                              )),
                            ],
                          ),
                        ),

                        Container(
                          width: context.w(36),
                          height: context.w(36),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F2F5),
                            borderRadius:
                            BorderRadius.circular(context.w(10)),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(Icons.more_vert,
                                size: context.sp(20),
                                color: const Color(0xFF1F2A44)),
                            onPressed: () =>
                                _showProfileBottomSheet(context, controller),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: context.h(isTablet ? 20 : 14)),

                  // ── Section label ─────────────────────────────────────────
                  Padding(
                    padding: EdgeInsets.only(
                        left: context.w(4), bottom: context.h(8)),
                    child: AppText(
                      data: 'settings'.tr,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade400,
                    ),
                  ),

                  // ── Settings Card ─────────────────────────────────────────
                  _SectionCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [

                        _SettingsTile(
                          icon: Icons.language_outlined,
                          label: 'change_language'.tr,
                          onTap: () =>
                              controller.showLanguageDialog(context),
                          trailing: GetBuilder<LanguageController>(
                            builder: (langCtrl) => AppText(
                              data: langCtrl.langCode == 'bg' ? 'BG' : 'EN',
                              fontSize: 13,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ),

                        _Divider(),

                        _SettingsTile(
                          icon: Icons.shield_outlined,
                          label: 'terms_privacy'.tr,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => TermsConditionPage()),
                          ),
                        ),

                        _Divider(),

                        _SettingsTile(
                          icon: Icons.logout_rounded,
                          label: 'logout'.tr,
                          iconColor: const Color(0xFFD94F4F),
                          labelColor: const Color(0xFFD94F4F),
                          onTap: controller.logout,
                          showArrow: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  void _showProfileBottomSheet(
      BuildContext context, ProfileController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(context.w(20))),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: context.w(16), vertical: context.h(8)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: context.w(40),
                height: context.h(4),
                margin: EdgeInsets.only(bottom: context.h(12)),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(context.w(2)),
                ),
              ),

              ListTile(
                contentPadding:
                EdgeInsets.symmetric(horizontal: context.w(4)),
                leading: Container(
                  width: context.w(36),
                  height: context.w(36),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F2F5),
                    borderRadius: BorderRadius.circular(context.w(10)),
                  ),
                  child: Icon(Icons.mode_edit_outlined,
                      color: const Color(0xFF1F2A44),
                      size: context.sp(18)),
                ),
                title: AppText(
                    data: 'edit'.tr,
                    fontSize: 15,
                    color: const Color(0xFF1F2A44)),
                onTap: () {
                  Navigator.pop(ctx);
                  controller.showEditUsernameDialog(context);
                },
              ),

              Divider(color: Colors.grey.shade100),

              Obx(() => ListTile(
                contentPadding:
                EdgeInsets.symmetric(horizontal: context.w(4)),
                leading: Container(
                  width: context.w(36),
                  height: context.w(36),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEEEE),
                    borderRadius: BorderRadius.circular(context.w(10)),
                  ),
                  child: controller.isDeleting.value
                      ? Padding(
                    padding: EdgeInsets.all(context.w(9)),
                    child: const CircularProgressIndicator(
                        strokeWidth: 2, color: Color(0xFFD94F4F)),
                  )
                      : Icon(Icons.delete_outline,
                      color: const Color(0xFFD94F4F),
                      size: context.sp(18)),
                ),
                title: AppText(
                    data: 'delete'.tr,
                    fontSize: 15,
                    color: const Color(0xFFD94F4F)),
                onTap: controller.isDeleting.value
                    ? null
                    : () {
                  Navigator.pop(ctx);
                  controller.deleteProfile(context);
                },
              )),

              SizedBox(height: context.h(8)),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Avatar or Lottie placeholder ──────────────────────────────────────────────

class _AvatarOrLottie extends StatefulWidget {
  final String imageUrl;
  final double radius;

  const _AvatarOrLottie({required this.imageUrl, required this.radius});

  @override
  State<_AvatarOrLottie> createState() => _AvatarOrLottieState();
}

class _AvatarOrLottieState extends State<_AvatarOrLottie>
    with SingleTickerProviderStateMixin {
  late final AnimationController _lottieController;

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4), // ⬅ increase to slow down
    );
    _lottieController.repeat();
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrl.isNotEmpty) {
      return CircleAvatar(
        radius: widget.radius,
        backgroundColor: const Color(0xFFE8EBF2),
        backgroundImage: NetworkImage(widget.imageUrl),
      );
    }

    return Container(
      width: widget.radius * 2,
      height: widget.radius * 2,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFE8EBF2),
      ),
      clipBehavior: Clip.antiAlias,
      child: Lottie.asset(
        'assets/lottie/avatar_placeholder.json',
        controller: _lottieController,
        fit: BoxFit.cover,
      ),
    );
  }
}
// ── Reusable card wrapper ─────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const _SectionCard({required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ??
          EdgeInsets.symmetric(
            horizontal: context.w(16),
            vertical: context.h(14),
          ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.w(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ── Settings row tile ─────────────────────────────────────────────────────────

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Widget? trailing;
  final Color? iconColor;
  final Color? labelColor;
  final bool showArrow;

  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
    this.iconColor,
    this.labelColor,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(context.w(16)),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.w(16),
          vertical: context.h(14),
        ),
        child: Row(
          children: [
            Container(
              width: context.w(36),
              height: context.w(36),
              decoration: BoxDecoration(
                color: (iconColor ?? const Color(0xFF1F2A44))
                    .withOpacity(0.08),
                borderRadius: BorderRadius.circular(context.w(10)),
              ),
              child: Icon(icon,
                  size: context.sp(18),
                  color: iconColor ?? const Color(0xFF1F2A44)),
            ),
            SizedBox(width: context.w(14)),
            Expanded(
              child: AppText(
                data: label,
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: labelColor ?? const Color(0xFF1F2A44),
              ),
            ),
            if (trailing != null) ...[
              trailing!,
              SizedBox(width: context.w(6)),
            ],
            if (showArrow)
              Icon(Icons.arrow_forward_ios_rounded,
                  size: context.sp(14),
                  color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}

// ── Thin divider ──────────────────────────────────────────────────────────────

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey.shade100,
      indent: context.w(66),
      endIndent: context.w(16),
    );
  }
}