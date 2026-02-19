import 'package:furniture_ecommerce_app/core/services/network/dio_client.dart';
import 'package:furniture_ecommerce_app/core/utils/typedef.dart';
import 'package:furniture_ecommerce_app/features/products/data/models/product_model.dart';

abstract class ProductRemoteDataSource {
  ResultFuture<List<ProductModel>> getProducts();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final DioClient _dioClient;

  ProductRemoteDataSourceImpl(this._dioClient);

  @override
  ResultFuture<List<ProductModel>> getProducts() {
    return _dioClient.get<List<ProductModel>>(
      '/products',
      parser: (data) => (data as List)
          .map((e) => ProductModel.fromApiJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
