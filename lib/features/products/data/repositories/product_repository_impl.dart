import 'package:furniture_ecommerce_app/core/utils/typedef.dart';
import 'package:furniture_ecommerce_app/features/products/data/datasources/product_remote_data_source.dart';
import 'package:furniture_ecommerce_app/features/products/domain/entities/category_list_item.dart';
import 'package:furniture_ecommerce_app/features/products/domain/entities/products_page_data.dart';
import 'package:furniture_ecommerce_app/features/products/domain/repositories/product_repository.dart';
import 'package:furniture_ecommerce_app/features/products/domain/use_cases/get_products_params.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource productRemoteDataSource;

  ProductRepositoryImpl(this.productRemoteDataSource);

  @override
  ResultFuture<ProductsPageData> getProducts(GetProductsParams params) async {
    final result = await productRemoteDataSource.getProducts(params);
    return result.map((response) => ProductsPageData(
          products: response.products,
          categories: response.categories,
          colors: response.colors,
          materials: response.materials,
          currentPage: response.currentPage,
          lastPage: response.lastPage,
          total: response.total,
          perPage: response.perPage,
        ));
  }

  @override
  ResultFuture<List<CategoryListItem>> getCategories() async {
    final result = await productRemoteDataSource.getCategories();
    return result.map((categories) => categories);
  }
}