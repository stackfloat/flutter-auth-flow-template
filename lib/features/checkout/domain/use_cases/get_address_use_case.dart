import 'package:furniture_ecommerce_app/core/utils/typedef.dart';
import 'package:furniture_ecommerce_app/features/checkout/domain/entities/address.dart';
import 'package:furniture_ecommerce_app/features/checkout/domain/repositories/address_repository.dart';

class GetAddressUseCase {
  final AddressRepository repository;

  GetAddressUseCase(this.repository);

  ResultFuture<Address> call(int id) => repository.getAddress(id);
}
