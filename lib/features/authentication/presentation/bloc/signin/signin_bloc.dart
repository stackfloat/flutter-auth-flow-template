import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_ecommerce_app/core/errors/failure.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/entities/user.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/errors/validation_exception.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/failures/account_disabled_failure.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/failures/auth_failure.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/failures/email_already_exists_failure.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/failures/invalid_credentials_failure.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/failures/username_already_exists_failure.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/usecases/signin_usecase.dart';
import 'package:furniture_ecommerce_app/features/authentication/presentation/bloc/signin/signin_errors.dart';
import 'package:furniture_ecommerce_app/features/authentication/presentation/bloc/signup/signup_errors.dart';
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
    // Perform all validations on submit
    final uxErrors = SigninErrors(
      email: _emailUxError(state.email),
      password: _passwordUxError(state.password),
    );

    emit(state.copyWith(formSubmitted: true, errors: uxErrors));

    // 2️⃣ If UX errors exist → stop (better UX)
    if (uxErrors.hasErrors) return;

    emit(
      state.copyWith(
        status: SigninStatus.loading,
        serverError: null,
        authError: null,
      ),
    );

    final result = await signinUseCase(
      SigninParams(email: state.email, password: state.password),
    );

    result.fold(
      (failure) {
        if (failure is InvalidCredentialsFailure) {
          emit(
            state.copyWith(
              authError: 'Invalid email or password',
              serverError: null,
            ),
          );
        } else if (failure is AccountDisabledFailure) {
          emit(
            state.copyWith(
              authError: 'Your account has been disabled',
              serverError: null,
            ),
          );
        } else {
          emit(
            state.copyWith(
              serverError: 'Something went wrong. Please try again.',
              authError: null,
            ),
          );
        }
      },
      (user) {
        emit(state.copyWith(status: SigninStatus.success, user: user));
      },
    );
  }

  String? _emailUxError(String email) {
    if (email.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      return 'Invalid email';
    }
    return null;
  }

  String? _passwordUxError(String password) {
    if (password.isEmpty) {
      return 'Password is required';
    }
    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  SigninErrors _mapDomainExceptionToUiErrors(ValidationException exception) {
    if (exception is InvalidEmailException) {
      return const SigninErrors(email: 'Invalid email');
    }
    return SigninErrors.empty;
  }

  SigninErrors _mapFailureToUiErrors(Failure failure) {
    if (failure is InvalidCredentialsFailure) {
      return const SigninErrors(email: 'Invalid credentials');
    }

    if (failure is AccountDisabledFailure) {
      return const SigninErrors(email: 'Account disabled');
    }

    return SigninErrors.empty;
  }

  String _mapFailureToGlobalMessage(Failure failure) {
    if (failure is NetworkFailure) {
      return 'Network error. Please check your connection.';
    }

    if (failure is ServerFailure) {
      return 'Something went wrong. Please try again later.';
    }

    return 'Unexpected error occurred1.';
  }
}
