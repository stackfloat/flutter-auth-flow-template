import 'package:furniture_ecommerce_app/core/services/network/dio_client.dart';
import 'package:furniture_ecommerce_app/core/utils/typedef.dart';
import 'package:furniture_ecommerce_app/features/products/data/models/category_list_item_model.dart';
import 'package:furniture_ecommerce_app/features/products/data/models/products_response_model.dart';
import 'package:furniture_ecommerce_app/features/products/domain/use_cases/get_products_params.dart';

abstract class ProductRemoteDataSource {
  ResultFuture<ProductsResponseModel> getProducts(GetProductsParams params);
  ResultFuture<List<CategoryListItemModel>> getCategories();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final DioClient _dioClient;

  ProductRemoteDataSourceImpl(this._dioClient);

  @override
  ResultFuture<ProductsResponseModel> getProducts(GetProductsParams params) {
    return _dioClient.get<ProductsResponseModel>(
      '/products',
      queryParameters: {
        'page': params.page,
        if (params.categoryId.isNotEmpty) 'category_id': params.categoryId,
        if (params.materialId.isNotEmpty) 'material_id': params.materialId,
        if (params.colorId.isNotEmpty) 'color_id': params.colorId,
        if (params.sortBy.isNotEmpty) 'sort_by': params.sortBy,
        'min_price': params.minPrice.round(),
        'max_price': params.maxPrice.round(),
        if (params.search.isNotEmpty) 'search': params.search,
        if (params.isInitialLoad) 'initial': 1,
      },
      parser: (data) {
        if (data is! Map<String, dynamic>) {
          throw FormatException(
              'Expected object response, got: ${data.runtimeType}');
        }
        return ProductsResponseModel.fromApiJson(data);
      },
    );
  }

  @override
  ResultFuture<List<CategoryListItemModel>> getCategories() {
    return _dioClient.get<List<CategoryListItemModel>>(
      '/categories',
      parser: (data) {
        if (data is! Map<String, dynamic>) {
          throw FormatException(
              'Expected object response, got: ${data.runtimeType}');
        }

        final categoriesSection = data['categories'];
        if (categoriesSection is! Map<String, dynamic>) {
          return <CategoryListItemModel>[];
        }

        final categoriesData = categoriesSection['data'];
        if (categoriesData is! List) {
          return <CategoryListItemModel>[];
        }

        return categoriesData
            .map((e) => CategoryListItemModel.fromApiJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }
}
