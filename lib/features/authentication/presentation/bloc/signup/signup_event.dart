abstract class SignupEvent {}

class NameChanged extends SignupEvent {
  final String name;
  NameChanged(this.name);
}

class EmailChanged extends SignupEvent {
  final String email;
  EmailChanged(this.email);
}

class PasswordChanged extends SignupEvent {
  final String password;
  PasswordChanged(this.password);
}

class ConfirmPasswordChanged extends SignupEvent {
  final String confirmPassword;
  ConfirmPasswordChanged(this.confirmPassword);
}

class SignupSubmitted extends SignupEvent {}


class RevealPassword extends SignupEvent {
  final bool revealPassword;
  RevealPassword(this.revealPassword);
}

class RevealConfirmPassword extends SignupEvent {
  final bool revealConfirmPassword;
  RevealConfirmPassword(this.revealConfirmPassword);
}