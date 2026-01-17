import 'package:equatable/equatable.dart';
import '../errors/validation_exception.dart';

class Email extends Equatable {
  static final _regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  final String value;

  Email(String input)
      : value = input.trim() {
    if (!isValid(value)) {
      throw const InvalidEmailException();
    }
  }

  static bool isValid(String email) {
    return _regex.hasMatch(email.trim());
  }

  @override
  List<Object?> get props => [value];
}
