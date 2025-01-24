import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence_app/app/errors/error_bags.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:presence_app/app/errors/validation_error.dart';
import 'package:presence_app/app/helper/validators.dart';

class ForgotPasswordController extends GetxController with ErrorBags {
  RxBool isLoading = false.obs;
  late TextEditingController emailC;

  @override
  void checkFormValidity() {
    super.checkFormValidity();
    String? errEmail = Validators.validateEmail(this.emailC.text);
    if (errEmail != null) {
      errorBags.add(errEmail);
    }
  }

  void sendPasswordReset() async {
    this.isLoading.value = true;
    try {
      this.checkFormValidity();
      this.errorCheck();

      await FirebaseAuth.instance.setLanguageCode("en");
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailC.text);
      Get.snackbar(
          'Successfully sent password reset email!', 'Check your email inbox.');
    } on FirebaseAuthException catch (error) {
      print('error');
      print(error);
      if (error.code == 'invalid-verification-code') {
        Get.snackbar('Failed to reset!', 'Invalid Verification Code.');
      }
    } on ValidationError catch (error) {
      print(error.toString());
      Get.snackbar('Failed to login!', error.getMessage());
    } catch (error) {
      print(error);
      Get.snackbar('Internal Server Error!', 'Contact our customer service.');
    } finally {
      this.isLoading.value = false;
      Get.back();
    }
  }

  @override
  void onInit() {
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
}
