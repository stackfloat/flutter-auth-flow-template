class SignupErrors {
  final String? name;
  final String? email;
  final String? password;
  final String? confirmPassword;

  const SignupErrors({
    this.name,
    this.email,
    this.password,
    this.confirmPassword,
  });

  bool get hasErrors =>
      name != null ||
      email != null ||
      password != null ||
      confirmPassword != null;

  SignupErrors copyWith({
    Object? name = _unset,
    Object? email = _unset,
    Object? password = _unset,
    Object? confirmPassword = _unset,
  }) {
    return SignupErrors(
      name: name == _unset ? this.name : name as String?,
      email: email == _unset ? this.email : email as String?,
      password: password == _unset ? this.password : password as String?,
      confirmPassword: confirmPassword == _unset
          ? this.confirmPassword
          : confirmPassword as String?,
    );
  }

  static const _unset = Object();
  static const empty = SignupErrors();
}
