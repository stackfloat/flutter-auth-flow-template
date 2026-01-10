import '../value_objects/name.dart';
import '../value_objects/email.dart';
import '../value_objects/confirmed_password.dart';

class SignupParams {
  final Name name;
  final Email email;
  final ConfirmedPassword password;

  const SignupParams({
    required this.name,
    required this.email,
    required this.password,
  });
}
