import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_ecommerce_app/core/errors/failure.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/entities/user.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/errors/validation_exception.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/failures/auth_validation_failure.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/failures/account_disabled_failure.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/failures/invalid_credentials_failure.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/usecases/signin_usecase.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/value_objects/email.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/value_objects/password.dart';
import 'package:furniture_ecommerce_app/features/authentication/presentation/bloc/signin/signin_errors.dart';
import 'package:meta/meta.dart';

part 'signin_event.dart';
part 'signin_state.dart';

class SigninBloc extends Bloc<SigninEvent, SigninState> {
  final SigninUseCase signinUseCase;

  SigninBloc(this.signinUseCase) : super(const SigninState()) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<SigninSubmitted>(_onSigninSubmitted);
    on<RevealPassword>(_onRevealPassword);
  }

  void _onRevealPassword(RevealPassword event, Emitter<SigninState> emit) {
    emit(state.copyWith(revealPassword: event.revealPassword));
  }

  void _onEmailChanged(EmailChanged event, Emitter<SigninState> emit) {
    emit(
      state.copyWith(
        email: event.email,
        serverError: null,
        authError: null,
        errors: state.formSubmitted
            ? state.errors.copyWith(email: _emailUxError(event.email))
            : state.errors,
      ),
    );
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<SigninState> emit) {
    emit(
      state.copyWith(
        password: event.password,
        serverError: null,
        authError: null,
        errors: state.formSubmitted
            ? state.errors.copyWith(password: _passwordUxError(event.password))
            : state.errors,
      ),
    );
  }

  void _onSigninSubmitted(
    SigninSubmitted event,
    Emitter<SigninState> emit,
  ) async {
    if (state.status == SigninStatus.loading) return;

    // Perform all validations on submit
    final uxErrors = SigninErrors(
      email: _emailUxError(state.email),
      password: _passwordUxError(state.password),
    );

    emit(
      state.copyWith(
        formSubmitted: true,
        errors: uxErrors,
        serverError: null,
        authError: null,
      ),
    );

    // 2️⃣ If UX errors exist → stop (better UX)
    if (uxErrors.hasErrors) return;

    try {
      final params = SigninParams(
        email: Email(state.email),
        password: Password(state.password),
      );

      emit(
        state.copyWith(
          status: SigninStatus.loading,
          serverError: null,
          authError: null,
        ),
      );

      final result = await signinUseCase(params);

      result.fold(
        (failure) {
          if (failure is InvalidCredentialsFailure) {
            emit(
              state.copyWith(
                authError: 'Invalid email or password',
                serverError: null,
                status: SigninStatus.failure,
              ),
            );
          } else if (failure is AccountDisabledFailure) {
            emit(
              state.copyWith(
                authError: 'Your account has been disabled',
                serverError: null,
                status: SigninStatus.failure,
              ),
            );
          } else if (failure is AuthValidationFailure) {
            emit(
              state.copyWith(
                errors: _mapValidationFailureToUiErrors(failure),
                authError: null,
                serverError: null,
                status: SigninStatus.failure,
              ),
            );
          } else {
            emit(
              state.copyWith(
                serverError: _mapFailureToGlobalMessage(failure),
                authError: null,
                status: SigninStatus.failure,
              ),
            );
          }
        },
        (user) {
          emit(state.copyWith(status: SigninStatus.success, user: user));
        },
      );
    } on ValidationException catch (e) {
      emit(
        state.copyWith(
          status: SigninStatus.initial,
          errors: _mapDomainExceptionToUiErrors(e),
        ),
      );
    }
  }

  String? _emailUxError(String email) {
    if (email.isEmpty) {
      return 'Email is required';
    }
    if (!Email.isValid(email)) {
      return 'Invalid email';
    }
    return null;
  }

  String? _passwordUxError(String password) {
    if (password.isEmpty) {
      return 'Password is required';
    }
    if (!Password.isValid(password)) {
      return 'Password must be at least ${Password.minLength} characters';
    }
    return null;
  }

  SigninErrors _mapDomainExceptionToUiErrors(ValidationException exception) {
    if (exception is InvalidEmailException) {
      return const SigninErrors(email: 'Invalid email address');
    }

    if (exception is WeakPasswordException) {
      return SigninErrors(
        password: 'Password must be at least ${Password.minLength} characters',
      );
    }

    return SigninErrors.empty;
  }

  SigninErrors _mapValidationFailureToUiErrors(
    AuthValidationFailure failure,
  ) {
    String? firstError(List<String>? errors) {
      if (errors == null || errors.isEmpty) return null;
      return errors.first;
    }

    final errors = failure.fieldErrors;

    return SigninErrors(
      email: firstError(errors['email']),
      password: firstError(errors['password']),
    );
  }

  String _mapFailureToGlobalMessage(Failure failure) {
    if (failure is NetworkFailure) {
      return 'Network error. Please check your connection.';
    }

    if (failure is ServerFailure) {
      return 'Something went wrong. Please try again later.';
    }

    if (failure is ApiFailure) {
      if (failure.statusCode == 0) {
        return 'Network error. Please check your connection.';
      }
      return 'Something went wrong. Please try again later.';
    }

    return 'Unexpected error occurred.';
  }
}
