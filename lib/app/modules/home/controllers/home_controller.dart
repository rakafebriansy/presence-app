import 'package:get/get.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:presence_app/app/routes/app_pages.dart';

class HomeController extends GetxController {
  RxBool isLoading = false.obs;
  FirebaseAuth auth = FirebaseAuth.instance;

  void logout() async {
    this.isLoading.value = true;
    try {
      await auth.signOut();
      Get.offAllNamed(Routes.LOGIN);
    } catch (error) {
      Get.snackbar('Internal Server Error', 'Contact our customer service..');
    } finally {
      this.isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
