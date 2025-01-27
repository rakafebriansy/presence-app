import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyAttendancesController extends GetxController {
  Future<QuerySnapshot<Map<String, dynamic>>> getAttendances() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      return await FirebaseFirestore.instance
          .collection('employees')
          .doc(uid)
          .collection('attendances')
          .orderBy('date', descending: true)
          .get();
    } on FirebaseException catch (error) {
      print(error);
      Get.snackbar('Failed to load data!', '${error.message}.');
      throw Exception('Failed to fetch attendances: ${error.message}');
    } catch (error) {
      Get.snackbar('Failed to load data!', error.toString());
      throw Exception('An unexpected error occurred: $error');
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
