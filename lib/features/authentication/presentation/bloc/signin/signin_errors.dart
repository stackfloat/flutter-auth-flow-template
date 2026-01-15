import 'package:equatable/equatable.dart';

class SigninErrors extends Equatable {
  final String? email;
  final String? password;

  const SigninErrors({this.email, this.password});

  bool get hasErrors => email != null || password != null;

  SigninErrors copyWith({
    Object? email = _unset,
    Object? password = _unset,
  }) {
    return SigninErrors(
      email: email == _unset ? this.email : email as String?,
      password: password == _unset ? this.password : password as String?,
    );
  }

  static const _unset = Object();
  static const empty = SigninErrors();

  @override
  List<Object?> get props => [email, password];
}
