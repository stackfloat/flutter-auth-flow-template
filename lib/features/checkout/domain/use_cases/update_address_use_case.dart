import 'package:furniture_ecommerce_app/core/utils/typedef.dart';
import 'package:furniture_ecommerce_app/features/checkout/domain/repositories/address_repository.dart';
import 'package:furniture_ecommerce_app/features/checkout/domain/use_cases/update_address_params.dart';

class UpdateAddressUseCase {
  final AddressRepository repository;

  UpdateAddressUseCase(this.repository);

  ResultFuture<void> call(UpdateAddressParams params) =>
      repository.updateAddress(params);
}
