import 'package:furniture_ecommerce_app/core/utils/typedef.dart';
import 'package:furniture_ecommerce_app/features/profile/domain/entities/profile.dart';
import 'package:furniture_ecommerce_app/features/profile/domain/use_cases/change_password_params.dart';
import 'package:furniture_ecommerce_app/features/profile/domain/use_cases/update_profile_params.dart';

abstract class ProfileRepository {
  ResultFuture<Profile> getProfile();
  ResultFuture<Profile> updateProfile(UpdateProfileParams params);
  ResultFuture<void> changePassword(ChangePasswordParams params);
}
