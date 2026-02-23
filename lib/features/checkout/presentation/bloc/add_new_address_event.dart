part of 'add_new_address_bloc.dart';

sealed class AddNewAddressEvent extends Equatable {
  const AddNewAddressEvent();

  @override
  List<Object?> get props => [];
}

final class AddNewAddressChanged extends AddNewAddressEvent {
  final String? fullName;
  final String? address;
  final String? city;
  final String? stateRegion;
  final String? zip;
  final String? country;
  final String? phoneNumber;

  const AddNewAddressChanged({
    this.fullName,
    this.address,
    this.city,
    this.stateRegion,
    this.zip,
    this.country,
    this.phoneNumber,
  });

  @override
  List<Object?> get props =>
      [fullName, address, city, stateRegion, zip, country, phoneNumber];
}

final class AddNewAddressSaved extends AddNewAddressEvent {
  const AddNewAddressSaved();
}
