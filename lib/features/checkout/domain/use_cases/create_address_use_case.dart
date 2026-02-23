import 'package:furniture_ecommerce_app/core/usecases/usecase.dart';
import 'package:furniture_ecommerce_app/core/utils/typedef.dart';
import 'package:furniture_ecommerce_app/features/checkout/domain/repositories/address_repository.dart';
import 'package:furniture_ecommerce_app/features/checkout/domain/use_cases/create_address_params.dart';

class CreateAddressUseCase implements UseCase<void, CreateAddressParams> {
  final AddressRepository repository;

  CreateAddressUseCase(this.repository);

  @override
  ResultFuture<void> call(CreateAddressParams params) {
    return repository.createAddress(params);
  }
}
