import 'package:furniture_ecommerce_app/core/usecases/usecase.dart';
import 'package:furniture_ecommerce_app/core/utils/typedef.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/entities/user.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/repositories/auth_repository.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/usecases/signup_params.dart';

class SignupUseCase implements UseCase<User, SignupParams> {
  final AuthRepository repository;

  SignupUseCase(this.repository);
  
  @override
  ResultFuture<User> call(SignupParams params) async {
    return repository.signup(params.name.value, params.email.value, params.password.password.value,);
  }
}


