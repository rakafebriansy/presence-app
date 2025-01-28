import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:presence_app/app/errors/error_bags.dart';
import 'package:presence_app/app/errors/validation_error.dart';
import 'package:presence_app/app/helper/validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UpdateProfileController extends GetxController with ErrorBags {
  RxBool isLoading = false.obs;
  late TextEditingController nameC;
  late TextEditingController emailC;
  late TextEditingController identificationNumberC;
  String? image;

  XFile? pickedImage;

  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    this.pickedImage = await picker.pickImage(source: ImageSource.gallery);
    update();
  }

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

  void deleteImageProfile() async {
    try {
      String uid = await FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('employees')
          .doc(uid)
          .update({'image': FieldValue.delete()});
      this.image = null;
      update();
      Get.back();
      Get.snackbar('Successfully update profile!', 'Your profile is updated.');
    } on FirebaseException catch (error) {
      print(error);
      Get.snackbar('Failed to delete image!', error.message!);
    } catch (error) {
      print(error);
      Get.snackbar('Internal Server Error!', 'Contact our customer service.');
    } finally {
      this.isLoading.value = false;
    }
  }

  void updateProfile() async {
    this.isLoading.value = true;
    try {
      this.checkFormValidity();
      this.errorCheck();

      String uid = await FirebaseAuth.instance.currentUser!.uid;
      Map<String, String> data = <String, String>{
        'name': this.nameC.text,
        'identification_number': this.identificationNumberC.text,
      };

      if (pickedImage != null) {
        FirebaseStorage storage = FirebaseStorage.instance;
        File file = File(this.pickedImage!.path);
        String extension = this.pickedImage!.name.split('.').last;
        await storage.ref('/$uid/profile.$extension').putFile(file);

        String imageUrl =
            await storage.ref('/$uid/profile.$extension').getDownloadURL();
        data.addAll({'image': imageUrl});
      }

      await FirebaseFirestore.instance
          .collection('employees')
          .doc(uid)
          .update(data);

      Get.back();
      Get.snackbar('Successfully update profile!', 'Your profile is updated.');
    } on FirebaseException catch (error) {
      print(error);
      Get.snackbar('Failed to update profile!', error.message!);
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
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    final DocumentSnapshot<Map<String, dynamic>> user =
        await FirebaseFirestore.instance.collection('employees').doc(uid).get();
    if (user.exists) {
      final Map<String, dynamic>? data = user.data();
      if (data != null) {
        this.nameC.text = data['name'];
        this.emailC.text = data['email'];
        this.identificationNumberC.text = data['identification_number'];
        this.image = data['image'] ?? null;
        update();
        return;
      }
    }
    throw new Exception('Internal Server Error');
  }
}
