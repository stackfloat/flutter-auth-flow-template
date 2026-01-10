import '../errors/validation_exception.dart';

class Name {
  final String value;

  Name(String input)
      : value = input.trim() {
    if (value.isEmpty || value.length < 3) {
      throw const InvalidNameException();
    }
  }
}
