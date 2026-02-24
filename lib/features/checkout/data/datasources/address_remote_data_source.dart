import 'package:furniture_ecommerce_app/core/services/network/dio_client.dart';
import 'package:furniture_ecommerce_app/core/utils/typedef.dart';
import 'package:furniture_ecommerce_app/features/checkout/data/models/address_model.dart';
import 'package:furniture_ecommerce_app/features/checkout/domain/use_cases/create_address_params.dart';
import 'package:furniture_ecommerce_app/features/checkout/domain/use_cases/update_address_params.dart';

abstract class AddressRemoteDataSource {
  ResultFuture<List<AddressModel>> getAddresses();
  ResultFuture<AddressModel> getAddress(int id);
  ResultFuture<void> createAddress(CreateAddressParams params);
  ResultFuture<void> updateAddress(UpdateAddressParams params);
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
  ResultFuture<AddressModel> getAddress(int id) {
    return _dioClient.get<AddressModel>(
      '/addresses/$id',
      parser: (data) {
        final addressData = _extractAddressMap(data);
        if (addressData == null) {
          throw FormatException(
            'Could not parse address from response. Expected data, data.address, or data as address object. Got: ${data.runtimeType}',
          );
        }
        return AddressModel.fromApiJson(addressData);
      },
    );
  }

  /// Extracts address map from various API response structures.
  Map<String, dynamic>? _extractAddressMap(dynamic data) {
    if (data == null) return null;
    if (data is Map<String, dynamic>) {
      // data.address
      final addr = data['address'];
      if (addr is Map<String, dynamic>) return addr;
      // data.data
      final inner = data['data'];
      if (inner is Map<String, dynamic>) {
        final addrFromInner = inner['address'];
        if (addrFromInner is Map<String, dynamic>) return addrFromInner;
        if (inner.containsKey('id') || inner.containsKey('name')) return inner;
      }
      if (inner is List && inner.isNotEmpty) {
        final first = inner.first;
        if (first is Map<String, dynamic>) return first;
      }
      // data itself is the address (has id or name)
      if (data.containsKey('id') || data.containsKey('name')) return data;
    }
    return null;
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

  @override
  ResultFuture<void> updateAddress(UpdateAddressParams params) {
    return _dioClient.patch<void>(
      '/addresses/${params.id}',
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
