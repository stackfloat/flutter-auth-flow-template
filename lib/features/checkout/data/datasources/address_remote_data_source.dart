import 'package:furniture_ecommerce_app/core/services/network/dio_client.dart';
import 'package:furniture_ecommerce_app/core/utils/typedef.dart';
import 'package:furniture_ecommerce_app/features/checkout/data/models/address_model.dart';
import 'package:furniture_ecommerce_app/features/checkout/domain/use_cases/create_address_params.dart';

abstract class AddressRemoteDataSource {
  ResultFuture<List<AddressModel>> getAddresses();
  ResultFuture<void> createAddress(CreateAddressParams params);
}

class AddressRemoteDataSourceImpl implements AddressRemoteDataSource {
  final DioClient _dioClient;

  AddressRemoteDataSourceImpl(this._dioClient);

  @override
  ResultFuture<List<AddressModel>> getAddresses() {
    return _dioClient.get<List<AddressModel>>(
      '/addresses',
      parser: _parseAddressesResponse,
    );
  }

  List<AddressModel> _parseAddressesResponse(dynamic data) {
    if (data is! Map<String, dynamic>) return [];
    final payload = data['data'] is Map<String, dynamic>
        ? data['data'] as Map<String, dynamic>
        : data;
    final raw = payload['addresses'];
    if (raw is! List) return [];
    return raw
        .whereType<Map<String, dynamic>>()
        .map(AddressModel.fromApiJson)
        .toList();
  }

  @override
  ResultFuture<void> createAddress(CreateAddressParams params) {
    return _dioClient.post<void>(
      '/addresses',
      data: {
        'name': params.name,
        'phone': params.phone,
        'address': params.address,
        'city': params.city,
        'state': params.state,
        'zip': params.zip,
        'country': params.country,
      },
      parser: (_) => null,
    );
  }
}
