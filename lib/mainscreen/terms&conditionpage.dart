import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/TearmController/tearmController.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/TearmController/tearmController.dart';

class TermsConditionPage extends StatelessWidget {
  const TermsConditionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TermsController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'terms_privacy'.tr,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: Obx(() {
        // ── Loading ──────────────────────────────
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // ── Error / Empty ────────────────────────
        if (controller.terms.value == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('failed_to_load'.tr),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: controller.fetchTerms,
                  child: Text('retry'.tr),
                ),
              ],
            ),
          );
        }

        // ── Content ──────────────────────────────
        return Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.terms.value!.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  controller.terms.value!.content,
                  style: const TextStyle(fontSize: 14, height: 1.6),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
