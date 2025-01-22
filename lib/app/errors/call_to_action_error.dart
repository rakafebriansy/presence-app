import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        title: this.title,
        middleText: this.description,
        actions: [
          OutlinedButton(
              onPressed: () {
                this.callback();
              },
              child: Text(this.onSubmitText ?? 'SUBMIT')),
          OutlinedButton(
              onPressed: () => Get.back(),
              child: Text(this.onCancelText ?? 'CANCEL'))
        ]);
  }
}
