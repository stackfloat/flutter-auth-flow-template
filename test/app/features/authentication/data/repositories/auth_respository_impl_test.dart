import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:furniture_ecommerce_app/core/errors/failure.dart';
import 'package:furniture_ecommerce_app/core/services/storage/secure_storage_service.dart';
import 'package:furniture_ecommerce_app/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:furniture_ecommerce_app/features/authentication/data/models/user_model.dart';
import 'package:furniture_ecommerce_app/features/authentication/data/repositories/auth_respository_impl.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/failures/account_disabled_failure.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/failures/auth_validation_failure.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/failures/email_already_exists_failure.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/failures/invalid_credentials_failure.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/failures/username_already_exists_failure.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockSecureStorageService extends Mock implements SecureStorageService {}

void main() {
  late AuthRepositoryImpl authRepositoryImpl;
  late MockAuthRemoteDataSource mockAuthRemoteDataSource;
  late MockSecureStorageService mockSecureStorageService;

  setUp(() {
    mockAuthRemoteDataSource = MockAuthRemoteDataSource();
    mockSecureStorageService = MockSecureStorageService();
    authRepositoryImpl = AuthRepositoryImpl(
      mockAuthRemoteDataSource,
      mockSecureStorageService,
    );
  });

  final tUserModel = UserModel(
    id: 1,
    name: 'Test User',
    email: 'test@example.com',
    token: 'test-token',
  );

  group('login', () {
    const tEmail = 'test@example.com';
    const tPassword = 'password123';

    test('should save auth session and return User on successful login',
        () async {
      // Arrange
      when(() => mockAuthRemoteDataSource.login(any(), any()))
          .thenAnswer((_) async => Right(tUserModel));

      when(() => mockSecureStorageService.saveAuthSession(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
            userJson: any(named: 'userJson'),
            userId: any(named: 'userId'),
          )).thenAnswer((_) async => Future.value());

      // Act
      final result = await authRepositoryImpl.login(tEmail, tPassword);

      // Assert
      verify(() => mockAuthRemoteDataSource.login(tEmail, tPassword)).called(1);

      verify(() => mockSecureStorageService.saveAuthSession(
            accessToken: 'test-token',
            refreshToken: 'test-token',
            userJson: any(named: 'userJson'),
            userId: 1,
          )).called(1);

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return Right'),
        (user) {
          expect(user.id, 1);
          expect(user.name, 'Test User');
          expect(user.email, 'test@example.com');
        },
      );

      verifyNoMoreInteractions(mockAuthRemoteDataSource);
      verifyNoMoreInteractions(mockSecureStorageService);
    });

    test('should return InvalidCredentialsFailure on 401 error', () async {
      // Arrange
      final tApiFailure = ApiFailure(statusCode: 401, message: 'Unauthorized');

      when(() => mockAuthRemoteDataSource.login(any(), any()))
          .thenAnswer((_) async => Left(tApiFailure));

      // Act
      final result = await authRepositoryImpl.login(tEmail, tPassword);

      // Assert
      verify(() => mockAuthRemoteDataSource.login(tEmail, tPassword)).called(1);
      verifyNever(() => mockSecureStorageService.saveAuthSession(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
            userJson: any(named: 'userJson'),
            userId: any(named: 'userId'),
          ));

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<InvalidCredentialsFailure>()),
        (r) => fail('Should return Left'),
      );

      verifyNoMoreInteractions(mockAuthRemoteDataSource);
      verifyNoMoreInteractions(mockSecureStorageService);
    });

    test('should return AccountDisabledFailure on 403 error', () async {
      // Arrange
      final tApiFailure = ApiFailure(statusCode: 403, message: 'Forbidden');

      when(() => mockAuthRemoteDataSource.login(any(), any()))
          .thenAnswer((_) async => Left(tApiFailure));

      // Act
      final result = await authRepositoryImpl.login(tEmail, tPassword);

      // Assert
      verify(() => mockAuthRemoteDataSource.login(tEmail, tPassword)).called(1);
      
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<AccountDisabledFailure>()),
        (r) => fail('Should return Left'),
      );

      verifyNoMoreInteractions(mockAuthRemoteDataSource);
      verifyNoMoreInteractions(mockSecureStorageService);
    });

    test('should return AuthValidationFailure with field errors', () async {
      // Arrange
      final tApiFailure = ApiFailure(
        statusCode: 422,
        message: 'Validation failed',
        errors: {
          'email': ['Invalid email format'],
          'password': ['Password too short'],
        },
      );

      when(() => mockAuthRemoteDataSource.login(any(), any()))
          .thenAnswer((_) async => Left(tApiFailure));

      // Act
      final result = await authRepositoryImpl.login('invalid', 'short');

      // Assert
      verify(() => mockAuthRemoteDataSource.login('invalid', 'short')).called(1);
      
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<AuthValidationFailure>());
          final validationFailure = failure as AuthValidationFailure;
          expect(
              validationFailure.fieldErrors['email'], ['Invalid email format']);
          expect(
              validationFailure.fieldErrors['password'], ['Password too short']);
        },
        (r) => fail('Should return Left'),
      );

      verifyNoMoreInteractions(mockAuthRemoteDataSource);
      verifyNoMoreInteractions(mockSecureStorageService);
    });

    test('should return NetworkFailure on network error', () async {
      // Arrange
      final tApiFailure = ApiFailure(statusCode: 0, message: 'No connection');

      when(() => mockAuthRemoteDataSource.login(any(), any()))
          .thenAnswer((_) async => Left(tApiFailure));

      // Act
      final result = await authRepositoryImpl.login(tEmail, tPassword);

      // Assert
      verify(() => mockAuthRemoteDataSource.login(tEmail, tPassword)).called(1);
      
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (r) => fail('Should return Left'),
      );

      verifyNoMoreInteractions(mockAuthRemoteDataSource);
      verifyNoMoreInteractions(mockSecureStorageService);
    });

    test('should return ServerFailure on 500 error', () async {
      // Arrange
      final tApiFailure =
          ApiFailure(statusCode: 500, message: 'Internal server error');

      when(() => mockAuthRemoteDataSource.login(any(), any()))
          .thenAnswer((_) async => Left(tApiFailure));

      // Act
      final result = await authRepositoryImpl.login(tEmail, tPassword);

      // Assert
      verify(() => mockAuthRemoteDataSource.login(tEmail, tPassword)).called(1);
      
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (r) => fail('Should return Left'),
      );

      verifyNoMoreInteractions(mockAuthRemoteDataSource);
      verifyNoMoreInteractions(mockSecureStorageService);
    });

    test('should return ApiFailure unchanged on 4xx error without field errors',
        () async {
      // Arrange
      final tApiFailure = ApiFailure(statusCode: 400, message: 'Bad request');

      when(() => mockAuthRemoteDataSource.login(any(), any()))
          .thenAnswer((_) async => Left(tApiFailure));

      // Act
      final result = await authRepositoryImpl.login(tEmail, tPassword);

      // Assert
      verify(() => mockAuthRemoteDataSource.login(tEmail, tPassword)).called(1);
      
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ApiFailure>());
          expect((failure as ApiFailure).statusCode, 400);
          expect(failure.message, 'Bad request');
        },
        (r) => fail('Should return Left'),
      );

      verifyNoMoreInteractions(mockAuthRemoteDataSource);
      verifyNoMoreInteractions(mockSecureStorageService);
    });

    test('should return non-ApiFailure unchanged', () async {
      // Arrange
      const tCustomFailure = ServerFailure(message: 'Custom error');

      when(() => mockAuthRemoteDataSource.login(any(), any()))
          .thenAnswer((_) async => const Left(tCustomFailure));

      // Act
      final result = await authRepositoryImpl.login(tEmail, tPassword);

      // Assert
      verify(() => mockAuthRemoteDataSource.login(tEmail, tPassword)).called(1);
      
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect((failure as ServerFailure).message, 'Custom error');
        },
        (r) => fail('Should return Left'),
      );

      verifyNoMoreInteractions(mockAuthRemoteDataSource);
      verifyNoMoreInteractions(mockSecureStorageService);
    });

    test('should save correct JSON format to storage on success', () async {
      // Arrange
      when(() => mockAuthRemoteDataSource.login(any(), any()))
          .thenAnswer((_) async => Right(tUserModel));

      when(() => mockSecureStorageService.saveAuthSession(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
            userJson: any(named: 'userJson'),
            userId: any(named: 'userId'),
          )).thenAnswer((_) async => Future.value());

      // Act
      await authRepositoryImpl.login(tEmail, tPassword);

      // Assert
      verify(() => mockAuthRemoteDataSource.login(tEmail, tPassword)).called(1);
      
      final captured = verify(() => mockSecureStorageService.saveAuthSession(
            accessToken: captureAny(named: 'accessToken'),
            refreshToken: captureAny(named: 'refreshToken'),
            userJson: captureAny(named: 'userJson'),
            userId: captureAny(named: 'userId'),
          )).captured;

      final userJson = captured[2] as String;
      final decoded = jsonDecode(userJson) as Map<String, dynamic>;

      expect(decoded['id'], 1);
      expect(decoded['name'], 'Test User');
      expect(decoded['email'], 'test@example.com');
      expect(decoded.containsKey('token'), false); // token not stored in local JSON

      verifyNoMoreInteractions(mockAuthRemoteDataSource);
      verifyNoMoreInteractions(mockSecureStorageService);
    });
  });

  group('signup', () {
    const tName = 'Test User';
    const tEmail = 'test@example.com';
    const tPassword = 'password123';

    test('should save auth session and return User on successful signup',
        () async {
      // Arrange
      when(() => mockAuthRemoteDataSource.signup(any(), any(), any()))
          .thenAnswer((_) async => Right(tUserModel));

      when(() => mockSecureStorageService.saveAuthSession(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
            userJson: any(named: 'userJson'),
            userId: any(named: 'userId'),
          )).thenAnswer((_) async => Future.value());

      // Act
      final result =
          await authRepositoryImpl.signup(tName, tEmail, tPassword);

      // Assert
      verify(() => mockAuthRemoteDataSource.signup(tName, tEmail, tPassword))
          .called(1);

      verify(() => mockSecureStorageService.saveAuthSession(
            accessToken: 'test-token',
            refreshToken: 'test-token',
            userJson: any(named: 'userJson'),
            userId: 1,
          )).called(1);

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return Right'),
        (user) {
          expect(user.id, 1);
          expect(user.name, 'Test User');
          expect(user.email, 'test@example.com');
        },
      );

      verifyNoMoreInteractions(mockAuthRemoteDataSource);
      verifyNoMoreInteractions(mockSecureStorageService);
    });

    test('should return EmailAlreadyExistsFailure when email is taken',
        () async {
      // Arrange
      final tApiFailure = ApiFailure(
        statusCode: 422,
        message: 'Validation failed',
        errors: {
          'email': ['Email already exists'],
        },
      );

      when(() => mockAuthRemoteDataSource.signup(any(), any(), any()))
          .thenAnswer((_) async => Left(tApiFailure));

      // Act
      final result =
          await authRepositoryImpl.signup(tName, tEmail, tPassword);

      // Assert
      verify(() => mockAuthRemoteDataSource.signup(tName, tEmail, tPassword)).called(1);
      
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<EmailAlreadyExistsFailure>()),
        (r) => fail('Should return Left'),
      );

      verifyNoMoreInteractions(mockAuthRemoteDataSource);
      verifyNoMoreInteractions(mockSecureStorageService);
    });

    test('should return UsernameAlreadyExistsFailure when name is taken',
        () async {
      // Arrange
      final tApiFailure = ApiFailure(
        statusCode: 422,
        message: 'Validation failed',
        errors: {
          'name': ['Username already exists'],
        },
      );

      when(() => mockAuthRemoteDataSource.signup(any(), any(), any()))
          .thenAnswer((_) async => Left(tApiFailure));

      // Act
      final result =
          await authRepositoryImpl.signup(tName, tEmail, tPassword);

      // Assert
      verify(() => mockAuthRemoteDataSource.signup(tName, tEmail, tPassword)).called(1);
      
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<UsernameAlreadyExistsFailure>()),
        (r) => fail('Should return Left'),
      );

      verifyNoMoreInteractions(mockAuthRemoteDataSource);
      verifyNoMoreInteractions(mockSecureStorageService);
    });

    test('should return UsernameAlreadyExistsFailure when username is taken',
        () async {
      // Arrange
      final tApiFailure = ApiFailure(
        statusCode: 422,
        message: 'Validation failed',
        errors: {
          'username': ['Username already exists'],
        },
      );

      when(() => mockAuthRemoteDataSource.signup(any(), any(), any()))
          .thenAnswer((_) async => Left(tApiFailure));

      // Act
      final result =
          await authRepositoryImpl.signup(tName, tEmail, tPassword);

      // Assert
      verify(() => mockAuthRemoteDataSource.signup(tName, tEmail, tPassword)).called(1);
      
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<UsernameAlreadyExistsFailure>()),
        (r) => fail('Should return Left'),
      );

      verifyNoMoreInteractions(mockAuthRemoteDataSource);
      verifyNoMoreInteractions(mockSecureStorageService);
    });

    test('should return AuthValidationFailure with other field errors',
        () async {
      // Arrange
      final tApiFailure = ApiFailure(
        statusCode: 422,
        message: 'Validation failed',
        errors: {
          'password': ['Password too weak'],
        },
      );

      when(() => mockAuthRemoteDataSource.signup(any(), any(), any()))
          .thenAnswer((_) async => Left(tApiFailure));

      // Act
      final result =
          await authRepositoryImpl.signup(tName, tEmail, tPassword);

      // Assert
      verify(() => mockAuthRemoteDataSource.signup(tName, tEmail, tPassword)).called(1);
      
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<AuthValidationFailure>());
          final validationFailure = failure as AuthValidationFailure;
          expect(validationFailure.fieldErrors['password'],
              ['Password too weak']);
        },
        (r) => fail('Should return Left'),
      );

      verifyNoMoreInteractions(mockAuthRemoteDataSource);
      verifyNoMoreInteractions(mockSecureStorageService);
    });

    test('should return NetworkFailure on network error', () async {
      // Arrange
      final tApiFailure = ApiFailure(statusCode: 0, message: 'No connection');

      when(() => mockAuthRemoteDataSource.signup(any(), any(), any()))
          .thenAnswer((_) async => Left(tApiFailure));

      // Act
      final result =
          await authRepositoryImpl.signup(tName, tEmail, tPassword);

      // Assert
      verify(() => mockAuthRemoteDataSource.signup(tName, tEmail, tPassword)).called(1);
      
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (r) => fail('Should return Left'),
      );

      verifyNoMoreInteractions(mockAuthRemoteDataSource);
      verifyNoMoreInteractions(mockSecureStorageService);
    });

    test('should return ServerFailure on 500 error', () async {
      // Arrange
      final tApiFailure =
          ApiFailure(statusCode: 500, message: 'Internal server error');

      when(() => mockAuthRemoteDataSource.signup(any(), any(), any()))
          .thenAnswer((_) async => Left(tApiFailure));

      // Act
      final result =
          await authRepositoryImpl.signup(tName, tEmail, tPassword);

      // Assert
      verify(() => mockAuthRemoteDataSource.signup(tName, tEmail, tPassword)).called(1);
      
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (r) => fail('Should return Left'),
      );

      verifyNoMoreInteractions(mockAuthRemoteDataSource);
      verifyNoMoreInteractions(mockSecureStorageService);
    });

    test('should return ApiFailure unchanged on 4xx error without field errors',
        () async {
      // Arrange
      final tApiFailure = ApiFailure(statusCode: 404, message: 'Not found');

      when(() => mockAuthRemoteDataSource.signup(any(), any(), any()))
          .thenAnswer((_) async => Left(tApiFailure));

      // Act
      final result =
          await authRepositoryImpl.signup(tName, tEmail, tPassword);

      // Assert
      verify(() => mockAuthRemoteDataSource.signup(tName, tEmail, tPassword)).called(1);
      
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ApiFailure>());
          expect((failure as ApiFailure).statusCode, 404);
          expect(failure.message, 'Not found');
        },
        (r) => fail('Should return Left'),
      );

      verifyNoMoreInteractions(mockAuthRemoteDataSource);
      verifyNoMoreInteractions(mockSecureStorageService);
    });

    test('should return non-ApiFailure unchanged', () async {
      // Arrange
      const tCustomFailure = NetworkFailure(message: 'Connection lost');

      when(() => mockAuthRemoteDataSource.signup(any(), any(), any()))
          .thenAnswer((_) async => const Left(tCustomFailure));

      // Act
      final result =
          await authRepositoryImpl.signup(tName, tEmail, tPassword);

      // Assert
      verify(() => mockAuthRemoteDataSource.signup(tName, tEmail, tPassword)).called(1);
      
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<NetworkFailure>());
          expect((failure as NetworkFailure).message, 'Connection lost');
        },
        (r) => fail('Should return Left'),
      );

      verifyNoMoreInteractions(mockAuthRemoteDataSource);
      verifyNoMoreInteractions(mockSecureStorageService);
    });

    test('should save correct JSON format to storage on success', () async {
      // Arrange
      when(() => mockAuthRemoteDataSource.signup(any(), any(), any()))
          .thenAnswer((_) async => Right(tUserModel));

      when(() => mockSecureStorageService.saveAuthSession(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
            userJson: any(named: 'userJson'),
            userId: any(named: 'userId'),
          )).thenAnswer((_) async => Future.value());

      // Act
      await authRepositoryImpl.signup(tName, tEmail, tPassword);

      // Assert
      verify(() => mockAuthRemoteDataSource.signup(tName, tEmail, tPassword)).called(1);
      
      final captured = verify(() => mockSecureStorageService.saveAuthSession(
            accessToken: captureAny(named: 'accessToken'),
            refreshToken: captureAny(named: 'refreshToken'),
            userJson: captureAny(named: 'userJson'),
            userId: captureAny(named: 'userId'),
          )).captured;

      final userJson = captured[2] as String;
      final decoded = jsonDecode(userJson) as Map<String, dynamic>;

      expect(decoded['id'], 1);
      expect(decoded['name'], 'Test User');
      expect(decoded['email'], 'test@example.com');
      expect(decoded.containsKey('token'), false); // token not stored in local JSON

      verifyNoMoreInteractions(mockAuthRemoteDataSource);
      verifyNoMoreInteractions(mockSecureStorageService);
    });
  });

  group('logout', () {
    test('should clear auth data and return Right on successful logout',
        () async {
      // Arrange
      when(() => mockAuthRemoteDataSource.logout())
          .thenAnswer((_) async => const Right(null));

      when(() => mockSecureStorageService.clearAuthData())
          .thenAnswer((_) async => Future.value());

      // Act
      final result = await authRepositoryImpl.logout();

      // Assert
      verify(() => mockAuthRemoteDataSource.logout()).called(1);
      verify(() => mockSecureStorageService.clearAuthData()).called(1);

      expect(result.isRight(), true);

      verifyNoMoreInteractions(mockAuthRemoteDataSource);
      verifyNoMoreInteractions(mockSecureStorageService);
    });

    test('should clear auth data even when remote logout fails', () async {
      // Arrange
      final tApiFailure =
          ApiFailure(statusCode: 500, message: 'Server error');

      when(() => mockAuthRemoteDataSource.logout())
          .thenAnswer((_) async => Left(tApiFailure));

      when(() => mockSecureStorageService.clearAuthData())
          .thenAnswer((_) async => Future.value());

      // Act
      final result = await authRepositoryImpl.logout();

      // Assert
      verify(() => mockAuthRemoteDataSource.logout()).called(1);
      verify(() => mockSecureStorageService.clearAuthData()).called(1);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (r) => fail('Should return Left'),
      );

      verifyNoMoreInteractions(mockAuthRemoteDataSource);
      verifyNoMoreInteractions(mockSecureStorageService);
    });
  });

  group('getUser', () {
    test('should return User when valid user JSON exists', () async {
      // Arrange
      final userJson = '{"id": 1, "name": "Test User", "email": "test@example.com"}';

      when(() => mockSecureStorageService.getUser())
          .thenAnswer((_) async => userJson);

      // Act
      final result = await authRepositoryImpl.getUser();

      // Assert
      verify(() => mockSecureStorageService.getUser()).called(1);
      expect(result, isNotNull);
      expect(result!.id, 1);
      expect(result.name, 'Test User');
      expect(result.email, 'test@example.com');

      verifyNoMoreInteractions(mockAuthRemoteDataSource);
      verifyNoMoreInteractions(mockSecureStorageService);
    });

    test('should return null when no user JSON exists', () async {
      // Arrange
      when(() => mockSecureStorageService.getUser())
          .thenAnswer((_) async => null);

      // Act
      final result = await authRepositoryImpl.getUser();

      // Assert
      verify(() => mockSecureStorageService.getUser()).called(1);
      expect(result, isNull);

      verifyNoMoreInteractions(mockAuthRemoteDataSource);
      verifyNoMoreInteractions(mockSecureStorageService);
    });

    test('should return null and delete user when JSON is invalid', () async {
      // Arrange
      const invalidJson = 'invalid json';

      when(() => mockSecureStorageService.getUser())
          .thenAnswer((_) async => invalidJson);

      when(() => mockSecureStorageService.deleteUser())
          .thenAnswer((_) async => Future.value());

      // Act
      final result = await authRepositoryImpl.getUser();

      // Assert
      verify(() => mockSecureStorageService.getUser()).called(1);
      verify(() => mockSecureStorageService.deleteUser()).called(1);
      expect(result, isNull);

      verifyNoMoreInteractions(mockAuthRemoteDataSource);
      verifyNoMoreInteractions(mockSecureStorageService);
    });

    test('should return null when decoded data is not a Map', () async {
      // Arrange
      const listJson = '["data"]';

      when(() => mockSecureStorageService.getUser())
          .thenAnswer((_) async => listJson);

      when(() => mockSecureStorageService.deleteUser())
          .thenAnswer((_) async => Future.value());

      // Act
      final result = await authRepositoryImpl.getUser();

      // Assert
      verify(() => mockSecureStorageService.getUser()).called(1);
      verify(() => mockSecureStorageService.deleteUser()).called(1);
      expect(result, isNull);

      verifyNoMoreInteractions(mockAuthRemoteDataSource);
      verifyNoMoreInteractions(mockSecureStorageService);
    });
  });

  group('clearSession', () {
    test('should call clearAuthData on storage service', () async {
      // Arrange
      when(() => mockSecureStorageService.clearAuthData())
          .thenAnswer((_) async => Future.value());

      // Act
      await authRepositoryImpl.clearSession();

      // Assert
      verify(() => mockSecureStorageService.clearAuthData()).called(1);

      verifyNoMoreInteractions(mockAuthRemoteDataSource);
      verifyNoMoreInteractions(mockSecureStorageService);
    });
  });
}
