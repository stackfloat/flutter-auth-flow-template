import '../errors/validation_exception.dart';

class Password {
  final String value;

  Password(String input) : value = input {
    if (value.isEmpty || value.length < 8) {
      throw const WeakPasswordException();
    }
  }
}
