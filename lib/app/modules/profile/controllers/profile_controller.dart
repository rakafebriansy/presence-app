import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:presence_app/app/routes/app_pages.dart';

class ProfileController extends GetxController {
  RxBool isLoading = false.obs;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> watchingUsers() async* {
    String uid = auth.currentUser!.uid;
    yield* firestore.collection('employees').doc(uid).snapshots();
  }

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
