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
      parser: (data) {
        if (data is! Map<String, dynamic>) {
          throw FormatException('Expected object response, got: ${data.runtimeType}');
        }
        final products = data['products'];
        if (products is! Map) {
          throw FormatException('Missing or invalid "products" in response');
        }
        final productsData = products['data'];
        if (productsData is! List) {
          throw FormatException('Missing or invalid "products.data" in response');
        }
        return productsData
            .map((e) => ProductModel.fromApiJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }
}
