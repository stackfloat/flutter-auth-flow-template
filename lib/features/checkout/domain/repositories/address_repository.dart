import 'package:furniture_ecommerce_app/core/utils/typedef.dart';
import 'package:furniture_ecommerce_app/features/checkout/domain/entities/address.dart';
import 'package:furniture_ecommerce_app/features/checkout/domain/use_cases/create_address_params.dart';
import 'package:furniture_ecommerce_app/features/checkout/domain/use_cases/update_address_params.dart';

abstract class AddressRepository {
  ResultFuture<List<Address>> getAddresses();
  ResultFuture<Address> getAddress(int id);
  ResultFuture<void> createAddress(CreateAddressParams params);
  ResultFuture<void> updateAddress(UpdateAddressParams params);
}
