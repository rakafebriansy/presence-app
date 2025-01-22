class ValidationError implements Exception {
  final List<String> _errorBags;
  ValidationError(this._errorBags);

  @override
  String toString() => 'ValidationError: ${_errorBags.toString()}';

  String getMessage() => this._errorBags.length > 1
      ? _errorBags[0] + " and ${this._errorBags.length} other errors."
      : _errorBags[0];
}
