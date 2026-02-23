import 'package:furniture_ecommerce_app/core/utils/typedef.dart';
import 'package:furniture_ecommerce_app/features/checkout/domain/entities/address.dart';
import 'package:furniture_ecommerce_app/features/checkout/domain/repositories/address_repository.dart';

class GetAddressesUseCase {
  final AddressRepository repository;

  GetAddressesUseCase(this.repository);

  ResultFuture<List<Address>> call() => repository.getAddresses();
}
