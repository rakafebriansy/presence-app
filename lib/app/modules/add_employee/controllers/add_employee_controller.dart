import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence_app/app/errors/error_bags.dart';
import 'package:presence_app/app/errors/validation_error.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:presence_app/app/helper/validators.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddEmployeeController extends GetxController with ErrorBags {
  RxBool isLoading = false.obs;
  late TextEditingController nameC;
  late TextEditingController identificationNumberC;
  late TextEditingController emailC;
  late TextEditingController adminPasswordC;

  @override
  void onInit() {
    super.onInit();
    this.nameC = TextEditingController();
    this.identificationNumberC = TextEditingController();
    this.emailC = TextEditingController();
    this.adminPasswordC = TextEditingController();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void checkFormValidity() {
    super.checkFormValidity();
    String? errAdminPassword =
        Validators.validatePassword(this.adminPasswordC.text);
    if (errAdminPassword != null) {
      errorBags.add(errAdminPassword);
    }
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

  Future<void> add() async {
    this.isLoading.value = true;
    Get.back();
    try {
      this.checkFormValidity();
      this.errorCheck();

      final FirebaseAuth auth = FirebaseAuth.instance;
      final String email = auth.currentUser!.email!;

      await auth.signInWithEmailAndPassword(
        email: email,
        password: adminPasswordC.text,
      );

      UserCredential credential = await auth.createUserWithEmailAndPassword(
        email: this.emailC.text,
        password: 'password',
      );

      if (credential.user == null) {
        throw new ValidationError(['User is not found.']);
      }

      String uid = credential.user!.uid;

      await credential.user!.sendEmailVerification();

      await FirebaseFirestore.instance.collection('employees').doc(uid).set({
        'identification_number': identificationNumberC.text,
        'email': emailC.text,
        'name': nameC.text,
        'role': 'employee',
        'created_at': DateTime.now().toIso8601String()
      });

      await auth.signInWithEmailAndPassword(
          email: email, password: adminPasswordC.text);
      Get.back();
      Get.snackbar('Successfully added new employee!',
          '${nameC.text} was added into database.');
    } on FirebaseAuthException catch (error) {
      print(error);
      if (error.code == 'weak-password') {
        Get.snackbar('Failed to add new employee!',
            'The password provided is too weak.');
      } else if (error.code == 'email-already-in-use') {
        Get.snackbar('Failed to add new employee!',
            'The account already exists for that email.');
      } else if (error.code == 'user-not-found' ||
          error.code == 'invalid-credential') {
        Get.snackbar('Failed to login!', 'Invalid Credentials.');
      }
    } on ValidationError catch (error) {
      print(error.toString());
      Get.snackbar('Failed to add new employee!', error.getMessage());
    } catch (error) {
      print(error);
      Get.snackbar('Internal Server Error!', 'Contact our customer service.');
    } finally {
      this.isLoading.value = false;
    }
  }
}
