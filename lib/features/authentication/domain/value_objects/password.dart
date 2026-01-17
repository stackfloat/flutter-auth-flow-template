import 'package:equatable/equatable.dart';
import '../errors/validation_exception.dart';

class Password extends Equatable {
  static const int minLength = 8;

  final String value;

  Password(String input) : value = input {
    if (!isValid(value)) {
      throw const WeakPasswordException();
    }
  }

  static bool isValid(String password) {
    return password.isNotEmpty && password.length >= minLength;
  }

  @override
  List<Object?> get props => [value];
}
