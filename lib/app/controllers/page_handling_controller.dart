import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presence_app/app/routes/app_pages.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';

class PageHandlingController extends GetxController {
  RxInt pageIndex = 0.obs;
  RxBool isLoading = false.obs;

  void changePage(int i) async {
    pageIndex.value = i;
    switch (i) {
      case 1:
        this.isLoading.value = true;
        try {
          Position position = await _determinePosition();
          final Map<String, String?> address =
              await _determinePlacemark(position);
          await _updatePosition(position, address);
          await _attend(position, address);
        } catch (error) {
          Get.snackbar('Failed to record attendance!', error.toString());
        } finally {
          this.isLoading.value = false;
          break;
        }
      case 2:
        Get.offAllNamed(Routes.PROFILE);
        break;
      default:
        Get.offAllNamed(Routes.HOME);
    }
  }

  Future<void> updateCurrentUserPosition() async {
    this.isLoading.value = true;
    try {
      final Position position = await _determinePosition();
      final Map<String, String?> address = await _determinePlacemark(position);
      await _updatePosition(position, address);
    } catch (error) {
      Get.snackbar('Failed to get location!', error.toString());
    } finally {
      this.isLoading.value = false;
    }
  }

  Future<void> _attend(Position position, Map<String, String?> address) async {
    try {
      String uid = await FirebaseAuth.instance.currentUser!.uid;

      CollectionReference<Map<String, dynamic>> attendancesCol =
          await FirebaseFirestore.instance
              .collection('employees')
              .doc(uid)
              .collection('attendances');
      DateTime now = DateTime.now();
      String todayAttendanceId = DateFormat('dd-MM-yyyy').format(now);

      DocumentSnapshot<Map<String, dynamic>> todayAttendanceDoc =
          await attendancesCol.doc(todayAttendanceId).get();
      if (todayAttendanceDoc.exists) {
        Map<String, dynamic>? todayAttendanceData = todayAttendanceDoc.data();
        if (todayAttendanceData?['out'] == null) {
          attendancesCol.doc(todayAttendanceId).update({
            'out': {
              'timestamp': now.toIso8601String(),
              'lat': position.latitude,
              'long': position.longitude,
              'address': address,
              'status': 'In range'
            }
          });
          Get.snackbar('Successfully checked-out!',
              'Attendance was recorded at ${DateFormat.Hms().format(DateTime.now())} o\'clock');
        } else {
          Get.snackbar('There\'s no schedule!',
              'Please check your schedule correctly.');
        }
      } else {
        attendancesCol.doc(todayAttendanceId).set({
          'date': now.toIso8601String(),
          'in': {
            'timestamp': now.toIso8601String(),
            'lat': position.latitude,
            'long': position.longitude,
            'address': address,
            'status': 'In range'
          }
        });
        Get.snackbar('Successfully checked-in!',
            'Attendance was recorded at ${DateFormat.Hms().format(DateTime.now())} o\'clock');
      }
    } catch (error) {
      throw error;
    }
  }

  Future<Map<String, String?>> _determinePlacemark(Position position) async {
    final List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    final Map<String, String?> address = {
      'street': placemarks[0].street,
      'country': placemarks[0].country,
      'administrative_area': placemarks[0].administrativeArea,
      if (placemarks[0].locality! != '') 'locality': placemarks[0].locality,
      if (placemarks[0].subLocality! != '')
        'sub_locality': placemarks[0].subLocality
    };
    return address;
  }

  Future<void> _updatePosition(
      Position position, Map<String, String?> address) async {
    try {
      String uid = await FirebaseAuth.instance.currentUser!.uid;

      FirebaseFirestore.instance.collection('employees').doc(uid).update({
        'position': {'lat': position.latitude, 'long': position.longitude},
        'address': {
          'locality': address['locality'],
          'country': address['country'],
          'administrative_area': address['administrative_area'],
        }
      });
    } catch (error) {
      throw error;
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
