import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presence_app/app/helper/custom_styles.dart';
import 'package:presence_app/app/routes/app_pages.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';

class PageHandlingController extends GetxController {
  RxInt pageIndex = 0.obs;
  RxBool isLoading = false.obs;
  Map<String, dynamic>? schedule;

  void changePage(int i) async {
    pageIndex.value = i;
    switch (i) {
      case 1:
        try {
          if (this.isLoading.value == false) {
            this.isLoading.value = true;
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

            if (todayAttendanceDoc.exists &&
                todayAttendanceDoc.data()!['in'] != null) {
              Map<String, dynamic>? todayAttendanceData =
                  todayAttendanceDoc.data();
              if (todayAttendanceData?['out'] == null) {
                Get.defaultDialog(
                    titleStyle:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    titlePadding: EdgeInsets.only(top: 12, left: 12, right: 12),
                    title: 'Checking out',
                    middleText:
                        'Are you sure you want to record your attendance now?',
                    actions: [
                      OutlinedButton(
                          onPressed: () => Get.back(), child: Text('CANCEL')),
                      ElevatedButton(
                        onPressed: () async {
                          await _attend(
                              'out', attendancesCol, todayAttendanceId, now);
                        },
                        child: Text('CHECK OUT'),
                        style: CustomStyles.roundedPrimaryButton(),
                      )
                    ]);
              } else {
                Get.snackbar('There\'s no schedule!',
                    'Please check your schedule correctly.');
              }
            } else {
              Get.defaultDialog(
                  titleStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  titlePadding: EdgeInsets.only(top: 12, left: 12, right: 12),
                  title: 'Checking in',
                  middleText:
                      'Are you sure you want to record your attendance now?',
                  actions: [
                    OutlinedButton(
                        onPressed: () => Get.back(), child: Text('CANCEL')),
                    ElevatedButton(
                      onPressed: () async {
                        await _attend(
                            'in', attendancesCol, todayAttendanceId, now);
                      },
                      child: Text('CHECK IN'),
                      style: CustomStyles.roundedPrimaryButton(),
                    ),
                  ]);
            }
          }
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
        await updateCurrentUserPosition();
        Get.offAllNamed(Routes.HOME);
    }
  }

  Stream<String> updateCurrentUserPosition() async* {
    this.isLoading.value = true;
    try {
      final Position position = await _determinePosition();
      final Map<String, String?> placemark =
          await _determinePlacemark(position);
      yield '${placemark['locality']}, ${placemark['administrative_area']}, ${placemark['country']}';
    } catch (error) {
      Get.snackbar('Failed to get location!', error.toString());
    } finally {
      this.isLoading.value = false;
    }
  }

  Text formatDuration(Duration duration, String key) {
    int hours = duration.inHours.abs();
    int minutes = duration.inMinutes.abs().remainder(60);
    int seconds = duration.inSeconds.abs().remainder(60);

    bool negative = duration.inSeconds.isNegative;

    List<String> parts = [];
    if (hours > 0) parts.add('$hours jam');
    if (minutes > 0) parts.add('$minutes menit');
    if (seconds > 0) parts.add('$seconds detik');

    if ((key == 'in' && negative) || (key == 'out' && !negative)) {
      return Text(
        'On Time',
        style: TextStyle(
            color: Colors.green, fontWeight: FontWeight.w600, fontSize: 12),
      );
    }
    return Text(
      '${hours > 0 ? '${hours} ${hours > 1 ? 'hours' : 'hour'} ' : ''}${minutes > 0 ? '${minutes} ${minutes > 1 ? 'minutes' : 'minute'} ' : ''}${seconds > 0 ? '${seconds} ${seconds > 1 ? 'seconds' : 'second'} ' : ''}${negative ? 'earlier' : 'late'}',
      style: TextStyle(fontSize: 12),
    );
  }

  Text getDifference(Map<String, dynamic> attendance, String key) {
    final String? timestampString = attendance[key]?['timestamp'];
    final DateTime? timestamp =
        timestampString != null ? DateTime.parse(timestampString) : null;

    if (timestamp == null || this.schedule == null) {
      return Text(
        '-',
        style: TextStyle(fontSize: 12),
      );
    }

    final Map<String, dynamic> scheduleTime =
        this.schedule?[key] as Map<String, dynamic>;

    final DateTime scheduleToday = DateTime(
      timestamp.year,
      timestamp.month,
      timestamp.day,
      scheduleTime['hour']!,
      scheduleTime['minute']!,
    );

    final Duration difference = timestamp.difference(scheduleToday);

    return formatDuration(difference, key);
  }

  Future<void> _attend(
      String mode,
      CollectionReference<Map<String, dynamic>> attendancesCol,
      String todayAttendanceId,
      DateTime now) async {
    try {
      Position position = await _determinePosition();
      final Map<String, String?> address = await _determinePlacemark(position);

      QuerySnapshot<Map<String, dynamic>> reachAreaDoc = await FirebaseFirestore
          .instance
          .collection('reach_area')
          .limit(1)
          .get();
      Map<String, dynamic>? reachAreaData = reachAreaDoc.docs.first.data();
      double distance = Geolocator.distanceBetween(
          double.parse(reachAreaData['lat']),
          double.parse(reachAreaData['long']),
          position.latitude,
          position.longitude);

      if (mode == 'out') {
        await attendancesCol.doc(todayAttendanceId).update({
          'out': {
            'timestamp': now.toIso8601String(),
            'lat': position.latitude,
            'long': position.longitude,
            'address': address,
            'distance': distance,
            'in_range': distance <= 200
          }
        });
      } else {
        await attendancesCol.doc(todayAttendanceId).set({
          'date': now.toIso8601String(),
          'in': {
            'timestamp': now.toIso8601String(),
            'lat': position.latitude,
            'long': position.longitude,
            'address': address,
            'distance': distance,
            'in_range': distance <= 200
          }
        });
      }
    } catch (error) {
      throw error;
    } finally {
      Get.back();
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

    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 30,
    );

    return await Geolocator.getCurrentPosition(
        locationSettings: locationSettings);
  }

  @override
  void onInit() async {
    super.onInit();
    final scheduleDoc =
        await FirebaseFirestore.instance.collection('schedule').limit(1).get();
    this.schedule = scheduleDoc.docs.first.data();
    update();
  }
}
