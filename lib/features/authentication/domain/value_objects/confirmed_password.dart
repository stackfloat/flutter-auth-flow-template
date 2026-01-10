import '../errors/validation_exception.dart';
import 'password.dart';

class ConfirmedPassword {
  final Password password;

  ConfirmedPassword({
    required String password,
    required String confirmation,
  }) : password = Password(password) {
    if (password != confirmation) {
      throw const PasswordMismatchException();
    }
  }
}
