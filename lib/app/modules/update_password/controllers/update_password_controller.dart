import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence_app/app/errors/error_bags.dart';
import 'package:presence_app/app/errors/validation_error.dart';
import 'package:presence_app/app/helper/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpdatePasswordController extends GetxController with ErrorBags {
  RxBool isLoading = false.obs;
  late TextEditingController currentPasswordC;
  late TextEditingController newPasswordC;
  late TextEditingController confirmNewPasswordC;
  RxBool isHidden = true.obs;
  RxBool isNewHidden = true.obs;
  RxBool isConfirmHidden = true.obs;

  @override
  void checkFormValidity() {
    super.checkFormValidity();
    String? errPassword =
        Validators.validateNewPassword(this.currentPasswordC.text);
    if (errPassword != null) {
      errorBags.add(errPassword);
    }
    String? errNewPassword =
        Validators.validateNewPassword(this.newPasswordC.text);
    if (errNewPassword != null) {
      errorBags.add(errNewPassword);
    }
    String? errConfirmNewPassword = Validators.validateConfirmPassword(
        this.newPasswordC.text, this.confirmNewPasswordC.text);
    if (errConfirmNewPassword != null) {
      errorBags.add(errConfirmNewPassword);
    }
  }

  void updatePassword() async {
    this.isLoading.value = true;
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      this.checkFormValidity();
      this.errorCheck();

      String email = auth.currentUser!.email!;

      await auth.signInWithEmailAndPassword(
          email: email, password: this.currentPasswordC.text);
      await auth.currentUser!.updatePassword(this.newPasswordC.text);

      Get.back();
      Get.snackbar(
          'Successfully update password!', 'Your password is updated.');
    } on FirebaseAuthException catch (error) {
      print(error);
      if (error.code == 'user-not-found' ||
          error.code == 'wrong-password' ||
          error.code == 'invalid-credential') {
        Get.snackbar('Failed to login!', 'Invalid Credentials.');
      } else if (error.code == 'weak-password') {
        Get.snackbar(
            'Failed to change password!', 'The password provided is too weak.');
      } else if (error.code == 'invalid-password') {
        Get.snackbar('Failed to change password!',
            'Password must be at least 6 characters long.');
      }
    } on ValidationError catch (error) {
      print(error.toString());
      Get.snackbar('Failed to update password!', error.getMessage());
    } catch (error) {
      print(error);
      Get.snackbar('Internal Server Error!', 'Contact our customer service.');
    } finally {
      this.isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    this.currentPasswordC = TextEditingController();
    this.newPasswordC = TextEditingController();
    this.confirmNewPasswordC = TextEditingController();
  }
}
