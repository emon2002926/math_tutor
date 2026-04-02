import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/util/screen_size.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/text/app_text.dart';
import '../controllers/tearm_controller.dart';
class TermsConditionPage extends StatelessWidget {
  const TermsConditionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TermsController());
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
          data: 'terms_privacy'.tr,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1F2A44),
        ),
        centerTitle: false,
      ),
      body: Obx(() {

        // ── Loading ───────────────────────────────────────────────────
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // ── Error / Empty ─────────────────────────────────────────────
        if (controller.terms.value == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline,
                    size: context.sp(48), color: Colors.grey.shade400),
                SizedBox(height: context.h(16)),
                AppText(
                  data: 'failed_to_load'.tr,
                  fontSize: 15,
                  color: Colors.grey.shade500,
                ),
                SizedBox(height: context.h(16)),
                AppButton(
                  buttonText: 'retry'.tr,
                  onPressed: controller.fetchTerms,
                  fillColor: const Color(0xFF1F2A44),
                  borderRadius: 12,
                  buttonHeight: 44,
                  buttonWidth: context.w(120),
                  fontSize: 14,
                ),
              ],
            ),
          );
        }

        // ── Content ───────────────────────────────────────────────────
        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: context.pagePadding,
                vertical: context.h(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── Title ───────────────────────────────────────────
                  AppText(
                    data: controller.terms.value!.title,
                    fontSize: isTablet ? 20 : 18,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1F2A44),
                    height: 1.4,
                  ),

                  SizedBox(height: context.h(16)),

                  // ── Divider ─────────────────────────────────────────
                  Divider(color: Colors.grey.shade200),

                  SizedBox(height: context.h(16)),

                  // ── Content ─────────────────────────────────────────
                  AppText(
                    data: controller.terms.value!.content,
                    fontSize: isTablet ? 15 : 14,
                    color: Colors.black87,
                    height: 1.7,
                    fontWeight: FontWeight.w400,
                    maxLines: 9999,
                    overflow: TextOverflow.visible,
                  ),

                  SizedBox(height: context.h(32)),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}