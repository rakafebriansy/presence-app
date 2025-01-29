import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence_app/app/helper/custom_styles.dart';

class CallToActionError {
  // Please verify your account first.

  final String title;
  final String description;
  final String? onSubmitText;
  final String? onCancelText;
  final Function callback;
  CallToActionError(
      {required this.title,
      required this.description,
      required this.callback,
      this.onSubmitText,
      this.onCancelText});

  @override
  String toString() =>
      'CallToActionError: ${'title:${this.title},description:${this.description}'}';

  dynamic getDialog() {
    Get.defaultDialog(
        titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        titlePadding: EdgeInsets.only(top: 12, left: 12, right: 12),
        title: this.title,
        middleText: this.description,
        actions: [
          OutlinedButton(
              onPressed: () => Get.back(),
              child: Text(this.onCancelText ?? 'CANCEL')),
          ElevatedButton(
            onPressed: () {
              this.callback();
            },
            child: Text(this.onSubmitText ?? 'SUBMIT'),
            style: CustomStyles.roundedPrimaryButton(),
          ),
        ]);
  }
}
