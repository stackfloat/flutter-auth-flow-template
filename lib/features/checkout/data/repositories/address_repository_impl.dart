import 'package:fpdart/fpdart.dart';
import 'package:furniture_ecommerce_app/core/errors/failure.dart';
import 'package:furniture_ecommerce_app/core/utils/typedef.dart';
import 'package:furniture_ecommerce_app/features/checkout/data/datasources/address_remote_data_source.dart';
import 'package:furniture_ecommerce_app/features/checkout/domain/entities/address.dart';
import 'package:furniture_ecommerce_app/features/checkout/domain/failures/address_validation_failure.dart';
import 'package:furniture_ecommerce_app/features/checkout/domain/repositories/address_repository.dart';
import 'package:furniture_ecommerce_app/features/checkout/domain/use_cases/create_address_params.dart';

class AddressRepositoryImpl implements AddressRepository {
  final AddressRemoteDataSource remoteDataSource;

  AddressRepositoryImpl(this.remoteDataSource);

  @override
  ResultFuture<List<Address>> getAddresses() async {
    final result = await remoteDataSource.getAddresses();
    return result.map((list) => list);
  }

  @override
  ResultFuture<void> createAddress(CreateAddressParams params) async {
    final result = await remoteDataSource.createAddress(params);
    return result.fold(
      (failure) async => Left(_mapFailure(failure)),
      (_) async => const Right(null),
    );
  }

  Failure _mapFailure(Failure failure) {
    if (failure is ApiFailure) {
      final errors = failure.errors ?? {};
      if (errors.isNotEmpty) {
        return AddressValidationFailure(errors);
      }

      if ((failure.statusCode ?? 0) == 0) {
        return NetworkFailure(message: failure.message);
      }

      if ((failure.statusCode ?? 0) >= 500) {
        return ServerFailure(message: failure.message);
      }
    }

    return failure;
  }
}
