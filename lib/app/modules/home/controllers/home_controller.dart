import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:presence_app/app/routes/app_pages.dart';

class HomeController extends GetxController {
  RxBool isLoading = false.obs;
  Map<String, dynamic>? user;

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

  Stream<QuerySnapshot<Map<String, dynamic>>> watchingLastAttendances() async* {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      yield* FirebaseFirestore.instance
          .collection('employees')
          .doc(uid)
          .collection('attendances')
          .orderBy('date', descending: true)
          .limitToLast(5)
          .snapshots();
    } on FirebaseException catch (error) {
      print(error);
      Get.snackbar('Failed to load data!', '${error.message}.');
    } catch (error) {
      Get.snackbar('Failed to load data!', error.toString());
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> watchingTodayAttendance() async* {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      String attendanceId = DateFormat('dd-MM-yyyy').format(DateTime.now());
      yield* FirebaseFirestore.instance
          .collection('employees')
          .doc(uid)
          .collection('attendances')
          .doc(attendanceId)
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
  void onInit() async {
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
