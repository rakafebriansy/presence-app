import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:presence_app/app/errors/error_bags.dart';
import 'package:presence_app/app/errors/validation_error.dart';
import 'package:presence_app/app/helper/validators.dart';

class UpdateProfileController extends GetxController with ErrorBags {
  RxBool isLoading = false.obs;
  late TextEditingController nameC;
  late TextEditingController emailC;
  late TextEditingController identificationNumberC;

  @override
  void checkFormValidity() {
    super.checkFormValidity();
    String? errName = Validators.validateName(this.nameC.text);
    if (errName != null) {
      errorBags.add(errName);
    }
    String? errEmail = Validators.validateEmail(this.emailC.text);
    if (errEmail != null) {
      errorBags.add(errEmail);
    }
    String? errIdentificationNumber = Validators.validateIdentificationNumber(
        this.identificationNumberC.text);
    if (errIdentificationNumber != null) {
      errorBags.add(errIdentificationNumber);
    }
  }

  void updateProfile() async {
    this.isLoading.value = true;
    try {
      this.checkFormValidity();
      this.errorCheck();

      String uid = await FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance.collection('employees').doc(uid).update({
        'name': this.nameC.text,
        'identification_number': this.identificationNumberC.text
      });

      Get.back();
      Get.snackbar('Successfully update profile!', 'Your profile is updated.');
    } on FirebaseException catch (error) {
      print(error);
      // TODO
      throw error;
    } on ValidationError catch (error) {
      print(error.toString());
      Get.snackbar('Failed to update profile!', error.getMessage());
    } catch (error) {
      print(error);
      Get.snackbar('Internal Server Error!', 'Contact our customer service.');
    } finally {
      this.isLoading.value = false;
    }
  }

  @override
  void onInit() async {
    super.onInit();
    this.nameC = TextEditingController();
    this.emailC = TextEditingController();
    this.identificationNumberC = TextEditingController();
    try {
      await _loadUserData();
    } on FirebaseException catch (error) {
      print(error);
      Get.snackbar('Failed to load profile!', '${error.message}.');
    } catch (error) {
      Get.snackbar('Failed to load profile!', error.toString());
    }
  }

  Future<void> _loadUserData() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot<Map<String, dynamic>> user =
        await FirebaseFirestore.instance.collection('employees').doc(uid).get();
    if (user.exists) {
      Map<String, dynamic>? data = user.data();
      if (data != null) {
        this.nameC.text = data['name'];
        this.emailC.text = data['email'];
        this.identificationNumberC.text = data['identification_number'];
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
