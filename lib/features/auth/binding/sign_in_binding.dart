import 'package:get/get.dart';

import '../controllers/signincontroller.dart';
class SignInBinding {
  static void dependencies(){
    Get.lazyPut<SignInController>(
          ()=> SignInController(),
      fenix: true,
    );
  }
}