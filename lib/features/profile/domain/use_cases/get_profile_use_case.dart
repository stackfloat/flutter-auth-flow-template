import 'package:furniture_ecommerce_app/core/utils/typedef.dart';
import 'package:furniture_ecommerce_app/features/profile/domain/entities/profile.dart';
import 'package:furniture_ecommerce_app/features/profile/domain/repositories/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  ResultFuture<Profile> call() => repository.getProfile();
}
