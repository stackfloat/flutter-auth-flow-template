import 'package:furniture_ecommerce_app/features/authentication/domain/failures/auth_failure.dart';

class AuthValidationFailure extends AuthFailure {
  const AuthValidationFailure(this.fieldErrors);

  final Map<String, List<String>> fieldErrors;

  @override
  List<Object?> get props => [fieldErrors];
}
