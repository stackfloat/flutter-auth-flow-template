import 'package:furniture_ecommerce_app/core/domain/usecases/usecase.dart';
import 'package:furniture_ecommerce_app/core/utils/typedef.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/entities/user.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/repositories/auth_repository.dart';

class SigninUseCase implements UseCase<User, SigninParams> {
  final AuthRepository repository;
  
  SigninUseCase(this.repository);
  
  @override
  ResultFuture<User> call(SigninParams params) async {
    return repository.login(params.email, params.password);
  }
}

class SigninParams {
  final String email;
  final String password;
  
  const SigninParams({
    required this.email,
    required this.password,
  });
}

