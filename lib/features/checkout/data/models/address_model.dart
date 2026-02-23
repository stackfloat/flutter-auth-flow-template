import 'package:furniture_ecommerce_app/features/checkout/domain/entities/address.dart';

class AddressModel extends Address {
  const AddressModel({
    required super.id,
    required super.name,
    required super.phone,
    required super.address,
    required super.city,
    required super.state,
    required super.zip,
    required super.country,
    required super.createdAt,
  });

  factory AddressModel.fromApiJson(Map<String, dynamic> json) {
    int parseInt(Object? value, {int fallback = 0}) {
      if (value is int) return value;
      if (value is num) return value.toInt();
      return int.tryParse(value?.toString() ?? '') ?? fallback;
    }

    String parseString(Object? value) => value?.toString() ?? '';

    return AddressModel(
      id: parseInt(json['id']),
      name: parseString(json['name']),
      phone: parseString(json['phone']),
      address: parseString(json['address']),
      city: parseString(json['city']),
      state: parseString(json['state']),
      zip: parseString(json['zip']),
      country: parseString(json['country']),
      createdAt: parseString(json['created_at']),
    );
  }
}
