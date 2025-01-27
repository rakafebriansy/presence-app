import 'package:get/get.dart';
import 'package:presence_app/app/routes/app_pages.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';

class PageHandlingController extends GetxController {
  RxInt pageIndex = 0.obs;
  RxBool isLoading = false.obs;

  void changePage(int i) async {
    // pageIndex.value = i;
    switch (i) {
      case 1:
        await updatePosition();
        Get.offAllNamed(Routes.PROFILE);
        break;
      case 2:
        Get.offAllNamed(Routes.PROFILE);
        break;
      default:
        Get.offAllNamed(Routes.HOME);
    }
  }

  Future<void> updatePosition() async {
    this.isLoading.value = true;
    try {
      Position position = await _determinePosition();
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark placemark = placemarks[0];
      String uid = await FirebaseAuth.instance.currentUser!.uid;

      FirebaseFirestore.instance.collection('employees').doc(uid).update({
        'position': {'lat': position.latitude, 'long': position.longitude},
        'address': {
          'street': placemark.street,
          'country': placemark.country,
          'administrative_area': placemark.administrativeArea,
          if (placemark.locality! != '') 'locality': placemark.locality,
          if (placemark.subLocality! != '')
            'sub_locality': placemark.subLocality
        }
      });
    } catch (error) {
      Get.snackbar('Failed to get location!', error.toString());
    } finally {
      this.isLoading.value = false;
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
