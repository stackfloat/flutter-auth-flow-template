import 'package:fpdart/fpdart.dart';
import 'package:furniture_ecommerce_app/core/errors/failure.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/entities/user.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/repositories/auth_repository.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/value_objects/email.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/value_objects/password.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/usecases/signin_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late SigninUseCase signinUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    signinUseCase = SigninUseCase(mockAuthRepository);
  });

  final tUserEntity = User(id: 1, name: 'Test User', email: 'test@example.com');
  final tEmail = Email('test@example.com');
  final tPassword = Password('password123');

  test('should call the [AuthRepository.login] method', () async {
    // Arrange
    when(
      () => mockAuthRepository.login(any(), any()),
    ).thenAnswer((_) async => Right(tUserEntity));

    // Act
    final result = await signinUseCase(
      SigninParams(email: tEmail, password: tPassword),
    );

    // Assert
    verify(() => mockAuthRepository.login(tEmail.value, tPassword.value))
        .called(1);

    expect(result, Right(tUserEntity));

    verifyNoMoreInteractions(mockAuthRepository);
  });

  test('should return [ApiFailure] when the API call fails', () async {
    // Arrange
    when(
      () => mockAuthRepository.login(any(), any()),
    ).thenAnswer((_) async => Left(ApiFailure(message: 'API call failed')));

    // Act
    final result = await signinUseCase(
      SigninParams(email: tEmail, password: tPassword),
    );

    // Assert
    verify(() => mockAuthRepository.login(tEmail.value, tPassword.value))
        .called(1);
    expect(result, Left(ApiFailure(message: 'API call failed')));
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
