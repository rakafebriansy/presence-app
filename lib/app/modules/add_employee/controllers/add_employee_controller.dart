import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence_app/app/errors/validation_error.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:presence_app/app/helper/validators.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddEmployeeController extends GetxController {
  final List<String> errorBags = [];
  late TextEditingController nameC;
  late TextEditingController identification_numberC;
  late TextEditingController emailC;

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void onInit() {
    this.nameC = TextEditingController();
    this.identification_numberC = TextEditingController();
    this.emailC = TextEditingController();
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

  void _checkFormValidity() {
    String? errName = Validators.validateName(this.nameC.text);
    if (errName != null) {
      errorBags.add(errName);
    }
    String? errEmail = Validators.validateEmail(this.emailC.text);
    if (errEmail != null) {
      errorBags.add(errEmail);
    }
    String? errIdentificationNumber = Validators.validateIdentificationNumber(
        this.identification_numberC.text);
    if (errIdentificationNumber != null) {
      errorBags.add(errIdentificationNumber);
    }
  }

  void add() async {
    try {
      this._checkFormValidity();
      if (this.errorBags.length > 0) {
        throw ValidationError(errorBags);
      }
      final UserCredential credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: this.emailC.text,
        password: 'password',
      );

      if (credential.user == null) {
        throw new ValidationError(['User is not found.']);
      }

      String uid = credential.user!.uid;

      await FirebaseFirestore.instance.collection('employees').add({
        'identification_number': identification_numberC.text,
        'email': emailC.text,
        'name': nameC.text,
        'uid': uid,
        'created_at': DateTime.now().toIso8601String()
      });

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
      }
    } on ValidationError catch (error) {
      print(error.toString());
      Get.snackbar('Failed to add new employee!', error.getMessage());
      this.errorBags.clear();
    } catch (error) {
      print(error);
      Get.snackbar('Internal Server Error!', 'Call the developer.');
    }
  }
}
