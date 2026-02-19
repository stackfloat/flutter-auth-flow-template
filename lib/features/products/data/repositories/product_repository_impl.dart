import 'package:furniture_ecommerce_app/core/utils/typedef.dart';
import 'package:furniture_ecommerce_app/features/products/data/datasources/product_remote_data_source.dart';
import 'package:furniture_ecommerce_app/features/products/domain/entities/product.dart';
import 'package:furniture_ecommerce_app/features/products/domain/repositories/product_repository.dart';
import 'package:furniture_ecommerce_app/features/products/domain/use_cases/get_products_params.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource productRemoteDataSource;

  ProductRepositoryImpl(this.productRemoteDataSource);

  @override
  ResultFuture<List<Product>> getProducts(GetProductsParams params) async {    
  return throw UnimplementedError();
  }
}