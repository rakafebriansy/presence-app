import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:presence_app/app/routes/app_pages.dart';

class HomeController extends GetxController {
  RxBool isLoading = false.obs;
  Map<String, dynamic>? user;

  void logout() async {
    this.isLoading.value = true;
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAllNamed(Routes.LOGIN);
    } catch (error) {
      Get.snackbar('Internal Server Error', 'Contact our customer service..');
    } finally {
      this.isLoading.value = false;
    }
  }

  @override
  void onInit() async {
    super.onInit();
    try {
      await _loadUserData();
    } on FirebaseException catch (error) {
      print(error);
      Get.snackbar('Failed to load data!', '${error.message}.');
    } catch (error) {
      Get.snackbar('Failed to load data!', error.toString());
    }
  }

  Future<void> _loadUserData() async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    final DocumentSnapshot<Map<String, dynamic>> user =
        await FirebaseFirestore.instance.collection('employees').doc(uid).get();
    if (user.exists) {
      final Map<String, dynamic>? data = user.data();
      if (data != null) {
        this.user = data;
        update();
        return;
      }
    }
    throw new Exception('Internal Server Error');
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
