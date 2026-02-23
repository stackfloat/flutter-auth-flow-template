import 'package:equatable/equatable.dart';

class CreateAddressParams extends Equatable {
  final String name;
  final String phone;
  final String address;
  final String city;
  final String state;
  final String zip;
  final String country;

  const CreateAddressParams({
    required this.name,
    required this.phone,
    required this.address,
    required this.city,
    required this.state,
    required this.zip,
    required this.country,
  });

  @override
  List<Object?> get props => [name, phone, address, city, state, zip, country];
}
