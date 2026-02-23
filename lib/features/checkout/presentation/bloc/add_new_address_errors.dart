import 'package:equatable/equatable.dart';

class AddNewAddressErrors extends Equatable {
  final String? fullName;
  final String? phoneNumber;
  final String? address;
  final String? city;
  final String? stateRegion;
  final String? zip;
  final String? country;

  const AddNewAddressErrors({
    this.fullName,
    this.phoneNumber,
    this.address,
    this.city,
    this.stateRegion,
    this.zip,
    this.country,
  });

  static const empty = AddNewAddressErrors();

  bool get hasErrors =>
      fullName != null ||
      phoneNumber != null ||
      address != null ||
      city != null ||
      stateRegion != null ||
      zip != null ||
      country != null;

  AddNewAddressErrors copyWith({
    Object? fullName = _unset,
    Object? phoneNumber = _unset,
    Object? address = _unset,
    Object? city = _unset,
    Object? stateRegion = _unset,
    Object? zip = _unset,
    Object? country = _unset,
  }) {
    return AddNewAddressErrors(
      fullName: fullName == _unset ? this.fullName : fullName as String?,
      phoneNumber:
          phoneNumber == _unset ? this.phoneNumber : phoneNumber as String?,
      address: address == _unset ? this.address : address as String?,
      city: city == _unset ? this.city : city as String?,
      stateRegion:
          stateRegion == _unset ? this.stateRegion : stateRegion as String?,
      zip: zip == _unset ? this.zip : zip as String?,
      country: country == _unset ? this.country : country as String?,
    );
  }

  static const _unset = Object();

  @override
  List<Object?> get props =>
      [fullName, phoneNumber, address, city, stateRegion, zip, country];
}
