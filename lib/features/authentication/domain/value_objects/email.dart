import '../errors/validation_exception.dart';

class Email {
  final String value;

  Email(String input)
      : value = input.trim() {
    if (!_isValid(value)) {
      throw const InvalidEmailException();
    }
  }

  static bool _isValid(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }
}
