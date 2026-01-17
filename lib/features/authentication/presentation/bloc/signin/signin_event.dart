part of 'signin_bloc.dart';

@immutable
sealed class SigninEvent extends Equatable {
  const SigninEvent();

  @override
  List<Object?> get props => [];
}

final class EmailChanged extends SigninEvent {
  final String email;
  const EmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

final class PasswordChanged extends SigninEvent {
  final String password;
  const PasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

final class SigninSubmitted extends SigninEvent {
  const SigninSubmitted();
}


final class RevealPassword extends SigninEvent {
  final bool revealPassword;
  const RevealPassword(this.revealPassword);

  @override
  List<Object?> get props => [revealPassword];
}