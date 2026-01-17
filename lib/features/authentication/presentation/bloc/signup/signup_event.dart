import 'package:equatable/equatable.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();
  @override
  List<Object?> get props => [];
}

class NameChanged extends SignupEvent {
  final String name;
  const NameChanged(this.name);
  @override
  List<Object?> get props => [name];
}

class EmailChanged extends SignupEvent {
  final String email;
  const EmailChanged(this.email);
  @override
  List<Object?> get props => [email];
}

class PasswordChanged extends SignupEvent {
  final String password;
  const PasswordChanged(this.password);
  @override
  List<Object?> get props => [password];
}

class ConfirmPasswordChanged extends SignupEvent {
  final String confirmPassword;
  const ConfirmPasswordChanged(this.confirmPassword);
  @override
  List<Object?> get props => [confirmPassword];
}

class SignupSubmitted extends SignupEvent {
  const SignupSubmitted();

  @override
  List<Object?> get props => [];
}


class RevealPassword extends SignupEvent {
  final bool revealPassword;
  const RevealPassword(this.revealPassword);
  @override
  List<Object?> get props => [revealPassword];
}

class RevealConfirmPassword extends SignupEvent {
  final bool revealConfirmPassword;
  const RevealConfirmPassword(this.revealConfirmPassword);
  @override
  List<Object?> get props => [revealConfirmPassword];
}