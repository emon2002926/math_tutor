import 'package:flutter_project/controller/TearmController/termsmodel.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/core/utils/storege_service.dart';

import '../../core/utils/api_service.dart';


class TermsController extends GetxController {
  final apiServices = Get.find<ApiServices>();
  final String? token = StorageService.accessToken;

  final terms     = Rxn<TermsModel>();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTerms();
  }

  Future<void> fetchTerms() async {
    isLoading.value = true;
    try {
      final response = await apiServices.get(
        '/api/users/terms-privacy/',
        headers: {'Authorization': 'Bearer $token'},
      );
      terms.value = TermsModel.fromJson(response as Map<String, dynamic>);
    } on HttpException catch (e) {
      print('FetchTerms Error ${e.statusCode}: ${e.body}');
      Get.snackbar(
        'Error',
        'Failed to load Terms and Privacy Policy',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    } finally {
      isLoading.value = false;
    }
  }
}