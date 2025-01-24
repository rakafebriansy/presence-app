import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence_app/app/errors/call_to_action_error.dart';
import 'package:presence_app/app/errors/error_bags.dart';
import 'package:presence_app/app/errors/validation_error.dart';
import 'package:presence_app/app/helper/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:presence_app/app/routes/app_pages.dart';

class LoginController extends GetxController with ErrorBags {
  late TextEditingController emailC;
  late TextEditingController passwordC;
  RxBool isLoading = false.obs;

  @override
  void checkFormValidity() {
    super.checkFormValidity();
    String? errEmail = Validators.validateEmail(this.emailC.text);
    if (errEmail != null) {
      errorBags.add(errEmail);
    }
    String? errPassword = Validators.validateName(this.passwordC.text);
    if (errPassword != null) {
      errorBags.add(errPassword);
    }
  }

  void login() async {
    this.isLoading.value = true;
    try {
      this.checkFormValidity();
      this.errorCheck();
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailC.text, password: passwordC.text);

      if (credential.user == null) {
        throw new ValidationError(['User is not found.']);
      } else if (!credential.user!.emailVerified) {
        throw new CallToActionError(
            title: 'Please verify your account first.',
            description: 'Click \'resend\' to re-send your verification email.',
            callback: () async {
              try {
                await credential.user!.sendEmailVerification();
                Get.back();
                Get.snackbar('Successfully re-sent email verification!',
                    'Check your email inbox.');
              } catch (error) {
                throw error;
              }
            },
            onSubmitText: 'RESEND');
      }

      if (passwordC.text == 'password') {
        Get.offAllNamed(Routes.NEW_PASSWORD);
      } else {
        Get.offAllNamed(Routes.HOME);
      }
    } on FirebaseAuthException catch (error) {
      print(error);
      if (error.code == 'user-not-found' ||
          error.code == 'wrong-password' ||
          error.code == 'invalid-credential') {
        Get.snackbar('Failed to login!', 'Invalid Credentials.');
      }
    } on ValidationError catch (error) {
      print(error.toString());
      Get.snackbar('Failed to login!', error.getMessage());
    } on CallToActionError catch (error) {
      error.getDialog();
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
    this.emailC = TextEditingController();
    this.passwordC = TextEditingController();
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
