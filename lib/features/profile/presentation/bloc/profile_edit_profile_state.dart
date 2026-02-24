part of 'profile_edit_profile_bloc.dart';

enum ProfileEditProfileStatus { initial, loading, ready, saving, success, failure }

class ProfileEditProfileState extends Equatable {
  final ProfileEditProfileStatus status;
  final int? profileId;
  final String name;
  final String email;
  final bool formSubmitted;
  final ProfileEditProfileErrors errors;
  final String? serverError;

  const ProfileEditProfileState({
    this.status = ProfileEditProfileStatus.initial,
    this.profileId,
    this.name = '',
    this.email = '',
    this.formSubmitted = false,
    this.errors = ProfileEditProfileErrors.empty,
    this.serverError,
  });

  ProfileEditProfileState copyWith({
    ProfileEditProfileStatus? status,
    Object? profileId = _unset,
    String? name,
    String? email,
    bool? formSubmitted,
    ProfileEditProfileErrors? errors,
    Object? serverError = _unset,
  }) {
    return ProfileEditProfileState(
      status: status ?? this.status,
      profileId: profileId == _unset ? this.profileId : profileId as int?,
      name: name ?? this.name,
      email: email ?? this.email,
      formSubmitted: formSubmitted ?? this.formSubmitted,
      errors: errors ?? this.errors,
      serverError: serverError == _unset ? this.serverError : serverError as String?,
    );
  }

  static const _unset = Object();

  @override
  List<Object?> get props => [
        status,
        profileId,
        name,
        email,
        formSubmitted,
        errors,
        serverError,
      ];
}

class ProfileEditProfileErrors extends Equatable {
  final String? name;
  final String? email;

  const ProfileEditProfileErrors({
    this.name,
    this.email,
  });

  static const empty = ProfileEditProfileErrors();

  bool get hasErrors => name != null || email != null;

  ProfileEditProfileErrors copyWith({
    Object? name = _unset,
    Object? email = _unset,
  }) {
    return ProfileEditProfileErrors(
      name: name == _unset ? this.name : name as String?,
      email: email == _unset ? this.email : email as String?,
    );
  }

  static const _unset = Object();

  @override
  List<Object?> get props => [name, email];
}
