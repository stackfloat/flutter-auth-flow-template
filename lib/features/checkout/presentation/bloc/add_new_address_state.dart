part of 'add_new_address_bloc.dart';

class AddNewAddressState extends Equatable {
  final String fullName;
  final String address;
  final String city;
  final String stateRegion;
  final String zip;
  final String country;
  final String phoneNumber;
  final bool isSaving;

  const AddNewAddressState({
    this.fullName = '',
    this.address = '',
    this.city = '',
    this.stateRegion = '',
    this.zip = '',
    this.country = 'US',
    this.phoneNumber = '',
    this.isSaving = false,
  });

  AddNewAddressState copyWith({
    String? fullName,
    String? address,
    String? city,
    String? stateRegion,
    String? zip,
    String? country,
    String? phoneNumber,
    bool? isSaving,
  }) {
    return AddNewAddressState(
      fullName: fullName ?? this.fullName,
      address: address ?? this.address,
      city: city ?? this.city,
      stateRegion: stateRegion ?? this.stateRegion,
      zip: zip ?? this.zip,
      country: country ?? this.country,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isSaving: isSaving ?? this.isSaving,
    );
  }

  @override
  List<Object?> get props => [
        fullName,
        address,
        city,
        stateRegion,
        zip,
        country,
        phoneNumber,
        isSaving,
      ];
}
