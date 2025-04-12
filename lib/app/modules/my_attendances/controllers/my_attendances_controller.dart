import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class MyAttendancesController extends GetxController {
  Rxn<DateTime> start = Rxn<DateTime>();
  Rxn<DateTime?> end = Rxn<DateTime>();

  late Future<QuerySnapshot<Map<String, dynamic>>> attendancesFuture;

  @override
  void onInit() {
    super.onInit();
    this.start.value = null;
    this.end.value = null;
    _loadAttendances();
  }

  void _loadAttendances() {
    attendancesFuture = getAttendances();
    update();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAttendances() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      Query<Map<String, dynamic>> query = FirebaseFirestore.instance
          .collection('employees')
          .doc(uid)
          .collection('attendances');
      if (start.value != null) {
        query = query.where('date',
            isGreaterThan: this.start.value!.toIso8601String());
        if (end.value != null) {
          query = query.where('date',
              isLessThan:
                  this.end.value!.add(Duration(days: 1)).toIso8601String());
        } else {
          query = query.where('date',
              isLessThan:
                  this.start.value!.add(Duration(days: 1)).toIso8601String());
        }
      }
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
    try {
      this.start.value = object.startDate;
      if (object.endDate != null) {
        this.end.value = object.endDate!;
      }
      _loadAttendances();
      if (Get.isDialogOpen ?? false || Get.isSnackbarOpen) {
        Get.back();
      }
    } catch (error) {
      Get.snackbar('Failed to load data!', error.toString());
      throw Exception('An unexpected error occurred: $error');
    }
  }

  void resetSortAttendances() {
    this.start.value = null;
    this.end.value = null;
    _loadAttendances();
  }
}
