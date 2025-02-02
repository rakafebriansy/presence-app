import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class MyAttendancesController extends GetxController {
  DateTime? start;
  DateTime? end;

  Future<QuerySnapshot<Map<String, dynamic>>> getAttendances() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      Query<Map<String, dynamic>> query = FirebaseFirestore.instance
          .collection('employees')
          .doc(uid)
          .collection('attendances');
      if (start != null) {
        query =
            query.where('date', isGreaterThan: this.start!.toIso8601String());
        if (end != null) {
          query = query.where('date',
              isLessThan: this.end!.add(Duration(days: 1)).toIso8601String());
        } else {
          query = query.where('date',
              isLessThan: this.start!.add(Duration(days: 1)).toIso8601String());
        }
      }
      this.start = null;
      this.end = null;
      return await query.orderBy('date', descending: true).get();
    } on FirebaseException catch (error) {
      print(error);
      Get.snackbar('Failed to load data!', '${error.message}.');
      throw Exception('Failed to fetch attendances: ${error.message}');
    } catch (error) {
      Get.snackbar('Failed to load data!', error.toString());
      throw Exception('An unexpected error occurred: $error');
    }
  }

  void sortAttendancesByDate(PickerDateRange object) {
    this.start = object.startDate;
    if (object.endDate != null) {
      this.end = object.endDate!;
    }
    update();
    Get.back();
  }
}
