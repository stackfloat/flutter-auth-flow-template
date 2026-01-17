import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:furniture_ecommerce_app/core/errors/failure.dart';
import 'package:furniture_ecommerce_app/core/services/storage/secure_storage_service.dart';
import 'package:furniture_ecommerce_app/core/utils/typedef.dart';
import 'package:furniture_ecommerce_app/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:furniture_ecommerce_app/features/authentication/data/models/user_model.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/entities/user.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/failures/account_disabled_failure.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/failures/auth_validation_failure.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/failures/email_already_exists_failure.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/failures/invalid_credentials_failure.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/failures/username_already_exists_failure.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final SecureStorageService secureStorageService;

  AuthRepositoryImpl(this.remoteDataSource, this.secureStorageService);

  @override
  ResultFuture<User> signup(String name, String email, String password) async {
    final result = await remoteDataSource.signup(name, email, password);

    return result.fold(
      (failure) async => Left(_mapSignupFailure(failure)),
      (userModel) async {
        await secureStorageService.saveAuthSession(
          accessToken: userModel.token,
          refreshToken: userModel.token,
          userJson: jsonEncode(userModel.toLocalJson()),
          userId: userModel.id,
        );

        return Right(userModel.toEntity());
      },
    );
  }

  @override
  ResultFuture<User> login(String email, String password) async {
    final result = await remoteDataSource.login(email, password);

    return result.fold(
      (failure) async => Left(_mapLoginFailure(failure)),
      (userModel) async {
        await secureStorageService.saveAuthSession(
          accessToken: userModel.token,
          refreshToken: userModel.token,
          userJson: jsonEncode(userModel.toLocalJson()),
          userId: userModel.id,
        );

        return Right(userModel.toEntity());
      },
    );
  }

  @override
  ResultFuture<void> logout() async {
    final result = await remoteDataSource.logout();

    await secureStorageService.clearAuthData();

    return result.fold(
      (failure) async => Left(_mapSystemFailure(failure)),
      (_) async => const Right(null),
    );
  }

  @override
  Future<User?> getUser() async {
    final userJson = await secureStorageService.getUser();
    if (userJson == null) return null;

    try {
      final decoded = jsonDecode(userJson);
      if (decoded is Map<String, dynamic>) {
        final userModel = UserModel.fromLocalJson(decoded);
        return userModel.toEntity();
      }
    } catch (_) {
      // ignore or log
    }

    // Optional: clear bad data
    await secureStorageService.deleteUser();
    return null;
  }

  @override
  Future<void> clearSession() async {
    await secureStorageService.clearAuthData();
  }

  Failure _mapSignupFailure(Failure failure) {
    if (failure is ApiFailure) {
      final errors = failure.errors ?? {};

      if (errors.containsKey('email')) {
        return const EmailAlreadyExistsFailure();
      }

      if (errors.containsKey('username') || errors.containsKey('name')) {
        return const UsernameAlreadyExistsFailure();
      }

      if (errors.isNotEmpty) {
        return AuthValidationFailure(errors);
      }
    }

    return _mapSystemFailure(failure);
  }

  Failure _mapLoginFailure(Failure failure) {
    if (failure is ApiFailure) {
      final statusCode = failure.statusCode ?? 0;

      if (statusCode == 401) {
        return const InvalidCredentialsFailure();
      }

      if (statusCode == 403) {
        return const AccountDisabledFailure();
      }

      final errors = failure.errors ?? {};
      if (errors.isNotEmpty) {
        return AuthValidationFailure(errors);
      }
    }

    return _mapSystemFailure(failure);
  }

  Failure _mapSystemFailure(Failure failure) {
    if (failure is ApiFailure) {
      final statusCode = failure.statusCode ?? 0;

      if (statusCode == 0) {
        return NetworkFailure(message: failure.message);
      }

      if (statusCode >= 500) {
        return ServerFailure(message: failure.message);
      }
    }

    return failure;
  }
}
