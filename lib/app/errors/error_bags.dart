import 'package:presence_app/app/errors/validation_error.dart';

mixin ErrorBags {
  final List<String> errorBags = [];

  void checkFormValidity() {
    this.errorBags.clear();
  }

  void errorCheck() {
    if (this.errorBags.length > 0) {
      throw ValidationError(errorBags);
    }
  }
}
