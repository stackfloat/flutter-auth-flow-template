part of 'profile_addresses_bloc.dart';

enum ProfileAddressesStatus { initial, loading, success, failure }

enum ProfileAddressEditStatus { initial, loading, success, failure }

class ProfileAddressesState extends Equatable {
  final List<Address> addresses;
  final ProfileAddressesStatus listStatus;
  final String? listError;

  /// For edit screen: the address being edited (null until loaded)
  final Address? addressForEdit;
  final ProfileAddressEditStatus editLoadStatus;
  final String? editLoadError;

  /// Form fields for edit (mirror add form)
  final String fullName;
  final String address;
  final String city;
  final String stateRegion;
  final String zip;
  final String country;
  final String phoneNumber;
  final bool formSubmitted;
  final ProfileAddressEditErrors errors;
  final String? serverError;
  final ProfileAddressEditStatus updateStatus;

  const ProfileAddressesState({
    this.addresses = const [],
    this.listStatus = ProfileAddressesStatus.initial,
    this.listError,
    this.addressForEdit,
    this.editLoadStatus = ProfileAddressEditStatus.initial,
    this.editLoadError,
    this.fullName = '',
    this.address = '',
    this.city = '',
    this.stateRegion = '',
    this.zip = '',
    this.country = 'US',
    this.phoneNumber = '',
    this.formSubmitted = false,
    this.errors = ProfileAddressEditErrors.empty,
    this.serverError,
    this.updateStatus = ProfileAddressEditStatus.initial,
  });

  ProfileAddressesState copyWith({
    List<Address>? addresses,
    ProfileAddressesStatus? listStatus,
    Object? listError = _unset,
    Address? addressForEdit,
    ProfileAddressEditStatus? editLoadStatus,
    Object? editLoadError = _unset,
    String? fullName,
    String? address,
    String? city,
    String? stateRegion,
    String? zip,
    String? country,
    String? phoneNumber,
    bool? formSubmitted,
    ProfileAddressEditErrors? errors,
    Object? serverError = _unset,
    ProfileAddressEditStatus? updateStatus,
  }) {
    return ProfileAddressesState(
      addresses: addresses ?? this.addresses,
      listStatus: listStatus ?? this.listStatus,
      listError: listError == _unset ? this.listError : listError as String?,
      addressForEdit: addressForEdit ?? this.addressForEdit,
      editLoadStatus: editLoadStatus ?? this.editLoadStatus,
      editLoadError: editLoadError == _unset ? this.editLoadError : editLoadError as String?,
      fullName: fullName ?? this.fullName,
      address: address ?? this.address,
      city: city ?? this.city,
      stateRegion: stateRegion ?? this.stateRegion,
      zip: zip ?? this.zip,
      country: country ?? this.country,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      formSubmitted: formSubmitted ?? this.formSubmitted,
      errors: errors ?? this.errors,
      serverError: serverError == _unset ? this.serverError : serverError as String?,
      updateStatus: updateStatus ?? this.updateStatus,
    );
  }

  static const _unset = Object();

  @override
  List<Object?> get props => [
        addresses,
        listStatus,
        listError,
        addressForEdit,
        editLoadStatus,
        editLoadError,
        fullName,
        address,
        city,
        stateRegion,
        zip,
        country,
        phoneNumber,
        formSubmitted,
        errors,
        serverError,
        updateStatus,
      ];
}

class ProfileAddressEditErrors extends Equatable {
  final String? fullName;
  final String? phoneNumber;
  final String? address;
  final String? city;
  final String? stateRegion;
  final String? zip;
  final String? country;

  const ProfileAddressEditErrors({
    this.fullName,
    this.phoneNumber,
    this.address,
    this.city,
    this.stateRegion,
    this.zip,
    this.country,
  });

  static const empty = ProfileAddressEditErrors();

  bool get hasErrors =>
      fullName != null ||
      phoneNumber != null ||
      address != null ||
      city != null ||
      stateRegion != null ||
      zip != null ||
      country != null;

  @override
  List<Object?> get props =>
      [fullName, phoneNumber, address, city, stateRegion, zip, country];
}
