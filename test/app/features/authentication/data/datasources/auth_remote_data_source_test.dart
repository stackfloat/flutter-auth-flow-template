import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:furniture_ecommerce_app/core/errors/failure.dart';
import 'package:furniture_ecommerce_app/core/services/network/dio_client.dart';
import 'package:furniture_ecommerce_app/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:furniture_ecommerce_app/features/authentication/data/models/user_model.dart';

class MockDioClient extends Mock implements DioClient {}

void main() {
  late AuthRemoteDataSourceImpl dataSource;
  late MockDioClient mockDioClient;

  setUp(() {
    mockDioClient = MockDioClient();
    dataSource = AuthRemoteDataSourceImpl(mockDioClient);
  });

  final tUserModel = UserModel(
    id: 1,
    name: 'Test User',
    email: 'test@example.com',
    token: 'test-token',
  );

  group('signup', () {
    const tName = 'Test User';
    const tEmail = 'test@example.com';
    const tPassword = 'password123';

    test('should call DioClient.post with correct endpoint and data', () async {
      // Arrange
      when(() => mockDioClient.post<UserModel>(
            any(),
            data: any(named: 'data'),
            parser: any(named: 'parser'),
          )).thenAnswer((_) async => Right(tUserModel));

      // Act
      await dataSource.signup(tName, tEmail, tPassword);

      // Assert
      verify(() => mockDioClient.post<UserModel>(
            '/register',
            data: {'name': tName, 'email': tEmail, 'password': tPassword},
            parser: any(named: 'parser'),
          )).called(1);

      verifyNoMoreInteractions(mockDioClient);
    });

    test('should return Right(UserModel) on success', () async {
      // Arrange
      when(() => mockDioClient.post<UserModel>(
            any(),
            data: any(named: 'data'),
            parser: any(named: 'parser'),
          )).thenAnswer((_) async => Right(tUserModel));    

      // Act
      final result = await dataSource.signup(tName, tEmail, tPassword);

      // Assert
      verify(() => mockDioClient.post<UserModel>(
            '/register',
            data: {'name': tName, 'email': tEmail, 'password': tPassword},
            parser: any(named: 'parser'),
          )).called(1);

      expect(result, equals(Right(tUserModel)));
      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return Right'),
        (user) {
          expect(user.id, 1);
          expect(user.name, 'Test User');
          expect(user.email, 'test@example.com');
          expect(user.token, 'test-token');
        },
      );

      verifyNoMoreInteractions(mockDioClient);
    });

    test('should return Left(Failure) when DioClient fails', () async {
      // Arrange
      const tFailure = ApiFailure(statusCode: 400, message: 'Bad request');

      when(() => mockDioClient.post<UserModel>(
            any(),
            data: any(named: 'data'),
            parser: any(named: 'parser'),
          )).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await dataSource.signup(tName, tEmail, tPassword);

      // Assert
      verify(() => mockDioClient.post<UserModel>(
            '/register',
            data: {'name': tName, 'email': tEmail, 'password': tPassword},
            parser: any(named: 'parser'),
          )).called(1);

      expect(result, equals(const Left(tFailure)));
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ApiFailure>());
          expect((failure as ApiFailure).statusCode, 400);
          expect(failure.message, 'Bad request');
        },
        (r) => fail('Should return Left'),
      );

      verifyNoMoreInteractions(mockDioClient);
    });
  });

  group('login', () {
    const tEmail = 'test@example.com';
    const tPassword = 'password123';

    test('should call DioClient.post with correct endpoint and data', () async {
      // Arrange
      when(() => mockDioClient.post<UserModel>(
            any(),
            data: any(named: 'data'),
            parser: any(named: 'parser'),
          )).thenAnswer((_) async => Right(tUserModel));

      // Act
      await dataSource.login(tEmail, tPassword);

      // Assert
      verify(() => mockDioClient.post<UserModel>(
            '/login',
            data: {'email': tEmail, 'password': tPassword},
            parser: any(named: 'parser'),
          )).called(1);

      verifyNoMoreInteractions(mockDioClient);
    });

    test('should return Right(UserModel) on success', () async {
      // Arrange
      when(() => mockDioClient.post<UserModel>(
            any(),
            data: any(named: 'data'),
            parser: any(named: 'parser'),
          )).thenAnswer((_) async => Right(tUserModel));

      // Act
      final result = await dataSource.login(tEmail, tPassword);

      // Assert
      verify(() => mockDioClient.post<UserModel>(
            '/login',
            data: {'email': tEmail, 'password': tPassword},
            parser: any(named: 'parser'),
          )).called(1);

      expect(result, equals(Right(tUserModel)));
      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return Right'),
        (user) {
          expect(user.id, 1);
          expect(user.name, 'Test User');
          expect(user.email, 'test@example.com');
          expect(user.token, 'test-token');
        },
      );

      verifyNoMoreInteractions(mockDioClient);
    });

    test('should return Left(Failure) when DioClient fails', () async {
      // Arrange
      const tFailure = ApiFailure(statusCode: 401, message: 'Unauthorized');

      when(() => mockDioClient.post<UserModel>(
            any(),
            data: any(named: 'data'),
            parser: any(named: 'parser'),
          )).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await dataSource.login(tEmail, tPassword);

      // Assert
      verify(() => mockDioClient.post<UserModel>(
            '/login',
            data: {'email': tEmail, 'password': tPassword},
            parser: any(named: 'parser'),
          )).called(1);

      expect(result, equals(const Left(tFailure)));
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ApiFailure>());
          expect((failure as ApiFailure).statusCode, 401);
          expect(failure.message, 'Unauthorized');
        },
        (r) => fail('Should return Left'),
      );

      verifyNoMoreInteractions(mockDioClient);
    });
  });

  group('logout', () {
    test('should call DioClient.post with correct endpoint', () async {
      // Arrange
      when(() => mockDioClient.post<void>(
            any(),
            parser: any(named: 'parser'),
          )).thenAnswer((_) async => const Right(null));

      // Act
      await dataSource.logout();

      // Assert
      verify(() => mockDioClient.post<void>(
            '/logout',
            parser: any(named: 'parser'),
          )).called(1);

      verifyNoMoreInteractions(mockDioClient);
    });

    test('should return Right(null) on success', () async {
      // Arrange
      when(() => mockDioClient.post<void>(
            any(),
            parser: any(named: 'parser'),
          )).thenAnswer((_) async => const Right(null));

      // Act
      final result = await dataSource.logout();

      // Assert
      verify(() => mockDioClient.post<void>(
            '/logout',
            parser: any(named: 'parser'),
          )).called(1);

      expect(result.isRight(), true);

      verifyNoMoreInteractions(mockDioClient);
    });

    test('should return Left(Failure) when DioClient fails', () async {
      // Arrange
      const tFailure = NetworkFailure(message: 'No connection');

      when(() => mockDioClient.post<void>(
            any(),
            parser: any(named: 'parser'),
          )).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await dataSource.logout();

      // Assert
      verify(() => mockDioClient.post<void>(
            '/logout',
            parser: any(named: 'parser'),
          )).called(1);

      expect(result, equals(const Left(tFailure)));
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<NetworkFailure>());
          expect((failure as NetworkFailure).message, 'No connection');
        },
        (r) => fail('Should return Left'),
      );

      verifyNoMoreInteractions(mockDioClient);
    });
  });
}
