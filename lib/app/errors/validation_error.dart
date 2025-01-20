class ValidationError implements Exception {
  final List<String> errorBags;
  ValidationError(this.errorBags);

  @override
  String toString() => 'InvalidAgeException: ${errorBags.toString()}';

  String getMessage() => this.errorBags.length > 0
      ? errorBags[0] + " and ${this.errorBags.length} other errors."
      : errorBags[0];
}
