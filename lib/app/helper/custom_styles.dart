import 'package:flutter/material.dart';

class CustomStyles {
  static ButtonStyle primaryButton() {
    return ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.blue),
        foregroundColor: WidgetStatePropertyAll(Colors.white),
        shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))));
  }
}
