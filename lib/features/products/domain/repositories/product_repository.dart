import 'package:furniture_ecommerce_app/core/utils/typedef.dart';
import 'package:furniture_ecommerce_app/features/products/domain/entities/products_page_data.dart';
import 'package:furniture_ecommerce_app/features/products/domain/use_cases/get_products_params.dart';

abstract class ProductRepository {
  ResultFuture<ProductsPageData> getProducts(GetProductsParams params);
}
