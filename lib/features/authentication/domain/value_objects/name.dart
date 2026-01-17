import 'package:equatable/equatable.dart';
import '../errors/validation_exception.dart';

class Name extends Equatable {
  static const int minLength = 3;

  final String value;

  Name(String input)
      : value = input.trim() {
    if (!isValid(value)) {
      throw const InvalidNameException();
    }
  }

  static bool isValid(String name) {
    return name.trim().isNotEmpty && name.trim().length >= minLength;
  }

  @override
  List<Object?> get props => [value];
}
