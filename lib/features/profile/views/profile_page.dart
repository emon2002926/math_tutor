import 'package:flutter/material.dart';
import 'package:flutter_project/features/terms_condition/views/terms_and_condition_page.dart';
import 'package:get/get.dart';
import '../../../core/widgets/text/app_text.dart';
import '../../language/controllers/language_controller.dart';
import '../controllers/profileController.dart';


class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: AppText(
          data: 'profile'.tr,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: false,
      ),
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            // ── Profile Card ──────────────────────
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundImage: controller.userImage.value.isNotEmpty
                        ? NetworkImage(controller.userImage.value)
                        : const NetworkImage("https://i.pravatar.cc/150?img=3"),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() => AppText(
                          data: controller.userName.value,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        )),
                        const SizedBox(height: 4),
                        Obx(() => AppText(
                          data: controller.userEmail.value,
                          fontSize: 13,
                          color: Colors.grey,
                        )),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        builder: (context) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.mode_edit_outlined, color: Colors.black),
                                title: AppText(data: 'edit'.tr, fontSize: 15),
                                onTap: () {
                                  Navigator.pop(context);
                                  controller.showEditUsernameDialog(context);
                                },
                              ),
                              const Divider(),
                              Obx(() => ListTile(
                                leading: controller.isDeleting.value
                                    ? const SizedBox(
                                  height: 20, width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.red),
                                )
                                    : const Icon(Icons.delete, color: Colors.black),
                                title: AppText(data: 'delete'.tr, fontSize: 15),
                                onTap: controller.isDeleting.value
                                    ? null
                                    : () {
                                  Navigator.pop(context);
                                  controller.deleteProfile(context);
                                },
                              )),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),

            // ── Change Language ───────────────────
            const SizedBox(height: 10),
            InkWell(
              onTap: () => controller.showLanguageDialog(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                margin: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.language, color: Colors.black),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppText(
                        data: 'change_language'.tr,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    // shows current active language
                    GetBuilder<LanguageController>(
                      builder: (langCtrl) => AppText(
                        data: langCtrl.langCode == 'bg' ? 'BG' : 'EN',
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black),
                  ],
                ),
              ),
            ),

            // ── Terms & Privacy ───────────────────
            const SizedBox(height: 10),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TermsConditionPage()));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                margin: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.safety_check, color: Colors.black),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppText(
                        data: 'terms_privacy'.tr,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black),
                  ],
                ),
              ),
            ),

            // ── Log Out ───────────────────────────
            const SizedBox(height: 10),
            InkWell(
              onTap: controller.logout,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                margin: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.logout, color: Colors.black),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppText(
                        data: 'logout'.tr,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}