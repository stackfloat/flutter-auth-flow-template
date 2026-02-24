import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_ecommerce_app/core/errors/failure.dart';
import 'package:furniture_ecommerce_app/features/profile/domain/use_cases/get_profile_use_case.dart';
import 'package:furniture_ecommerce_app/features/profile/domain/use_cases/update_profile_params.dart';
import 'package:furniture_ecommerce_app/features/profile/domain/use_cases/update_profile_use_case.dart';

part 'profile_edit_profile_event.dart';
part 'profile_edit_profile_state.dart';

class ProfileEditProfileBloc
    extends Bloc<ProfileEditProfileEvent, ProfileEditProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;

  ProfileEditProfileBloc(
    this.getProfileUseCase,
    this.updateProfileUseCase,
  ) : super(const ProfileEditProfileState()) {
    on<ProfileEditProfileLoadRequested>(_onLoadRequested);
    on<ProfileEditProfileFieldChanged>(_onFieldChanged);
    on<ProfileEditProfileSaveRequested>(_onSaveRequested);
  }

  Future<void> _onLoadRequested(
    ProfileEditProfileLoadRequested event,
    Emitter<ProfileEditProfileState> emit,
  ) async {
    emit(state.copyWith(
      status: ProfileEditProfileStatus.loading,
      serverError: null,
    ));

    final result = await getProfileUseCase();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProfileEditProfileStatus.failure,
          serverError: _mapFailureToMessage(failure),
        ),
      ),
      (profile) => emit(
        state.copyWith(
          status: ProfileEditProfileStatus.ready,
          profileId: profile.id,
          name: profile.name,
          email: profile.email,
          errors: ProfileEditProfileErrors.empty,
          formSubmitted: false,
          serverError: null,
        ),
      ),
    );
  }

  void _onFieldChanged(
    ProfileEditProfileFieldChanged event,
    Emitter<ProfileEditProfileState> emit,
  ) {
    final trimmed = event.value.trim();
    ProfileEditProfileState nextState = state;

    if (event.field == 'name') {
      nextState = state.copyWith(name: trimmed);
    } else if (event.field == 'email') {
      nextState = state.copyWith(email: trimmed);
    }

    emit(
      nextState.copyWith(
        serverError: null,
        errors: state.formSubmitted
            ? _validateForm(nextState)
            : nextState.errors.copyWith(
                email: event.field == 'email' ? null : nextState.errors.email,
              ),
      ),
    );
  }

  Future<void> _onSaveRequested(
    ProfileEditProfileSaveRequested event,
    Emitter<ProfileEditProfileState> emit,
  ) async {
    if (state.status == ProfileEditProfileStatus.saving) return;

    final errors = _validateForm(state);
    emit(state.copyWith(
      formSubmitted: true,
      errors: errors,
      serverError: null,
    ));
    if (errors.hasErrors) return;

    emit(state.copyWith(status: ProfileEditProfileStatus.saving));

    final result = await updateProfileUseCase(
      UpdateProfileParams(name: state.name, email: state.email),
    );

    result.fold(
      (failure) {
        if (failure is ApiFailure) {
          final emailFieldError = failure.getFieldError('email');
          final message = failure.message ?? '';
          final emailTakenFromMessage = message.toLowerCase().contains('email') &&
              (message.toLowerCase().contains('exist') ||
                  message.toLowerCase().contains('taken') ||
                  message.toLowerCase().contains('already'));

          if (emailFieldError != null || emailTakenFromMessage) {
            emit(state.copyWith(
              status: ProfileEditProfileStatus.ready,
              errors: state.errors.copyWith(
                email: emailFieldError ?? message,
              ),
              serverError: null,
            ));
            return;
          }
        }

        emit(state.copyWith(
          status: ProfileEditProfileStatus.ready,
          serverError: _mapFailureToMessage(failure),
        ));
      },
      (profile) => emit(state.copyWith(
        status: ProfileEditProfileStatus.success,
        profileId: profile.id,
        name: profile.name,
        email: profile.email,
        errors: ProfileEditProfileErrors.empty,
        serverError: null,
      )),
    );
  }

  ProfileEditProfileErrors _validateForm(ProfileEditProfileState state) {
    return ProfileEditProfileErrors(
      name: state.name.isEmpty ? 'Name is required' : null,
      email: _validateEmail(state.email),
    );
  }

  String? _validateEmail(String email) {
    if (email.isEmpty) return 'Email is required';
    final regex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!regex.hasMatch(email)) return 'Please enter a valid email';
    return null;
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is NetworkFailure) {
      return failure.message ?? 'Network error. Unexpected error occurred.';
    }
    if (failure is ServerFailure) {
      return failure.message ?? 'Something went wrong. Please try again later.';
    }
    if (failure is ApiFailure) {
      if (failure.statusCode == 0) {
        return failure.message ?? 'Network error. Unexpected error occurred.';
      }
      return failure.message ?? 'Something went wrong. Please try again later.';
    }
    return failure.message ?? 'Unexpected error occurred.';
  }
}
