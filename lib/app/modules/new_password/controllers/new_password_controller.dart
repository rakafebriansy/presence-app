import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence_app/app/errors/error_bags.dart';
import 'package:presence_app/app/errors/validation_error.dart';
import 'package:presence_app/app/helper/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:presence_app/app/routes/app_pages.dart';

class NewPasswordController extends GetxController with ErrorBags {
  RxBool isLoading = false.obs;
  late TextEditingController passwordC;
  late TextEditingController confirmPasswordC;

  void setPassword() async {
    this.isLoading.value = true;
    try {
      final auth = FirebaseAuth.instance;
      this.checkFormValidity();
      this.errorCheck();

      if (auth.currentUser == null) {
        throw new Exception('No User!');
      }
      String email = auth.currentUser!.email!;

      await auth.currentUser!.updatePassword(passwordC.text);

      await auth.signOut();

      await auth.signInWithEmailAndPassword(
          email: email, password: passwordC.text);

      Get.offAllNamed(Routes.HOME);
    } on FirebaseAuthException catch (error) {
      print(error);
      if (error.code == 'weak-password') {
        Get.snackbar(
            'Failed to change password!', 'The password provided is too weak.');
      } else if (error.code == 'invalid-password') {
        Get.snackbar('Failed to change password!',
            'Password must be at least 6 characters long.');
      }
    } on ValidationError catch (error) {
      print(error.toString());
      Get.snackbar('Failed to change password!', error.getMessage());
    } catch (error) {
      print(error);
      Get.snackbar('Internal Server Error!', 'Contact our customer service.');
    } finally {
      this.isLoading.value = false;
    }
  }

  @override
  void checkFormValidity() {
    super.checkFormValidity();
    String? errPassword = Validators.validateNewPassword(this.passwordC.text);
    if (errPassword != null) {
      errorBags.add(errPassword);
    }
    String? errConfirmPassword = Validators.validateConfirmPassword(
        this.passwordC.text, this.confirmPasswordC.text);
    if (errConfirmPassword != null) {
      errorBags.add(errConfirmPassword);
    }
  }

  @override
  void onInit() {
    this.passwordC = TextEditingController();
    this.confirmPasswordC = TextEditingController();

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
