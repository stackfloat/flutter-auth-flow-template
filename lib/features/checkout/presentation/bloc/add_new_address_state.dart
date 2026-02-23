part of 'add_new_address_bloc.dart';

enum AddNewAddressStatus { initial, loading, success, failure }

class AddNewAddressState extends Equatable {
  final String fullName;
  final String address;
  final String city;
  final String stateRegion;
  final String zip;
  final String country;
  final String phoneNumber;
  final bool formSubmitted;
  final AddNewAddressErrors errors;
  final String? serverError;
  final AddNewAddressStatus status;

  const AddNewAddressState({
    this.fullName = '',
    this.address = '',
    this.city = '',
    this.stateRegion = '',
    this.zip = '',
    this.country = 'US',
    this.phoneNumber = '',
    this.formSubmitted = false,
    this.errors = AddNewAddressErrors.empty,
    this.serverError,
    this.status = AddNewAddressStatus.initial,
  });

  AddNewAddressState copyWith({
    String? fullName,
    String? address,
    String? city,
    String? stateRegion,
    String? zip,
    String? country,
    String? phoneNumber,
    bool? formSubmitted,
    AddNewAddressErrors? errors,
    AddNewAddressStatus? status,
    Object? serverError = _unset,
  }) {
    return AddNewAddressState(
      fullName: fullName ?? this.fullName,
      address: address ?? this.address,
      city: city ?? this.city,
      stateRegion: stateRegion ?? this.stateRegion,
      zip: zip ?? this.zip,
      country: country ?? this.country,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      formSubmitted: formSubmitted ?? this.formSubmitted,
      errors: errors ?? this.errors,
      status: status ?? this.status,
      serverError: serverError == _unset ? this.serverError : serverError as String?,
    );
  }

  static const _unset = Object();

  @override
  List<Object?> get props => [
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
        status,
      ];
}
