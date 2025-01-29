import 'package:flutter/material.dart';

class CustomStyles {
  static ButtonStyle primaryButton() {
    return ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Color(0xFF8688BC)),
        foregroundColor: WidgetStatePropertyAll(Colors.white),
        shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))));
  }
  static ButtonStyle roundedPrimaryButton() {
    return ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Color(0xFF8688BC)),
        foregroundColor: WidgetStatePropertyAll(Colors.white),
        shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(99))));
  }
}
