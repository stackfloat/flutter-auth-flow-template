import 'package:furniture_ecommerce_app/core/domain/usecases/usecase.dart';
import 'package:furniture_ecommerce_app/core/utils/typedef.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/repositories/auth_repository.dart';

class LogoutUseCase implements UseCase<void, NoParams> {
  final AuthRepository repository;
  
  LogoutUseCase(this.repository);
  
  @override
  ResultFuture<void> call(NoParams params) async {
    return repository.logout();
  }
}

class NoParams {
  const NoParams();
}

