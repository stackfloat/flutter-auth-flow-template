import 'package:furniture_ecommerce_app/core/usecases/usecase.dart';
import 'package:furniture_ecommerce_app/core/utils/typedef.dart';
import 'package:furniture_ecommerce_app/features/products/domain/entities/products_page_data.dart';
import 'package:furniture_ecommerce_app/features/products/domain/repositories/product_repository.dart';
import 'package:furniture_ecommerce_app/features/products/domain/use_cases/get_products_params.dart';

class GetProductsUseCase
    implements UseCase<ProductsPageData, GetProductsParams> {
  final ProductRepository productRepository;

  GetProductsUseCase(this.productRepository);

  @override
  ResultFuture<ProductsPageData> call(GetProductsParams params) async {
    return await productRepository.getProducts(params);
  }
}

