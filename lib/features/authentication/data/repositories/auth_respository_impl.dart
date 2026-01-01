import 'package:fpdart/fpdart.dart';
import 'package:furniture_ecommerce_app/core/errors/exceptions.dart';
import 'package:furniture_ecommerce_app/core/errors/failure.dart';
import 'package:furniture_ecommerce_app/core/services/storage/secure_storage_service.dart';
import 'package:furniture_ecommerce_app/core/utils/typedef.dart';
import 'package:furniture_ecommerce_app/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/entities/user.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final SecureStorageService secureStorageService;

  AuthRepositoryImpl(this.remoteDataSource, this.secureStorageService);

  @override
  ResultFuture<User> signup(String name, String email, String password) async {
    try {
      final user = await remoteDataSource.signup(name, email, password);
      return Right(user.toEntity());
    } on ServerException catch (e) {
      return Left(ApiFailure(
        message: e.message ?? 'An error occurred',
        statusCode: e.statusCode ?? 500,
        errors: e.errors,
      ));
    } catch (e) {
      return Left(ApiFailure(
        message: 'An unexpected error occurred: ${e.toString()}',
        statusCode: 500,
      ));
    }
  }

  @override
  ResultFuture<User> login(String email, String password) async {
    try {
      final user = await remoteDataSource.login(email, password);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ApiFailure(
        message: e.message ?? 'An error occurred',
        statusCode: e.statusCode ?? 500,
        errors: e.errors,
      ));
    } catch (e) {
      return Left(ApiFailure(
        message: 'An unexpected error occurred: ${e.toString()}',
        statusCode: 500,
      ));
    }
  }

  @override
  ResultFuture<void> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ApiFailure(
        message: e.message ?? 'An error occurred',
        statusCode: e.statusCode ?? 500,
      ));
    } catch (e) {
      return Left(ApiFailure(
        message: 'An unexpected error occurred: ${e.toString()}',
        statusCode: 500,
      ));
    }
  }
}
