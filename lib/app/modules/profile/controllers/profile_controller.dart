import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:presence_app/app/routes/app_pages.dart';

class ProfileController extends GetxController {
  RxBool isLoading = false.obs;

  Stream<DocumentSnapshot<Map<String, dynamic>>> watchingUser() async* {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      yield* FirebaseFirestore.instance
          .collection('employees')
          .doc(uid)
          .snapshots();
    } on FirebaseException catch (error) {
      print(error);
      Get.snackbar('Failed to load data!', '${error.message}.');
    } catch (error) {
      Get.snackbar('Failed to load data!', error.toString());
    }
  }

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
