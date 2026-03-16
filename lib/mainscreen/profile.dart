import 'package:flutter/material.dart';
import 'package:flutter_project/mainscreen/terms&conditionpage.dart';
import 'package:get/get.dart';

import 'controllers/profileController.dart';


class Profile extends StatelessWidget {
  const Profile({super.key});

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
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),

      body: Obx(() {
        // Profile data loading
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            // ===========================
            // Profile Card
            // ===========================
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Profile Image
                  CircleAvatar(
                    radius: 26,
                    backgroundImage: controller.userImage.value.isNotEmpty
                        ? NetworkImage(controller.userImage.value)
                        : const NetworkImage("https://i.pravatar.cc/150?img=3"),
                  ),

                  const SizedBox(width: 12),

                  // Name & Email
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() => Text(
                          controller.userName.value,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        )),
                        const SizedBox(height: 4),
                        Obx(() => Text(
                          controller.userEmail.value,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        )),
                      ],
                    ),
                  ),

                  // 3 dot menu
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        builder: (context) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Edit
                              ListTile(
                                leading: const Icon(
                                  Icons.mode_edit_outlined,
                                  color: Colors.black,
                                ),
                                title: const Text("Edit"),
                                onTap: () {
                                  Navigator.pop(context);
                                  controller.showEditEmailDialog(context);
                                },
                              ),
                              const Divider(),

                              // Delete
                              Obx(() => ListTile(
                                leading: controller.isDeleting.value
                                    ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.red,
                                  ),
                                )
                                    : const Icon(
                                  Icons.delete,
                                  color: Colors.black,
                                ),
                                title: const Text("Delete"),
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

            // ===========================
            // Terms & Privacy
            // ===========================
            const SizedBox(height: 10),
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> Termsconditionpage()));
              },
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                margin: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    Icon(Icons.safety_check, color: Colors.black),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Terms and Privacy Policy",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black),
                  ],
                ),
              ),
            ),

            // ===========================
            // Log Out
            // ===========================
            const SizedBox(height: 10),
            InkWell(
              onTap: controller.logout,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                margin: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    Icon(Icons.logout, color: Colors.black),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Log Out",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black),
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