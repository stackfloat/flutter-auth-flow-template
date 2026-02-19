import 'package:furniture_ecommerce_app/core/usecases/usecase.dart';
import 'package:furniture_ecommerce_app/core/utils/typedef.dart';
import 'package:furniture_ecommerce_app/features/products/domain/entities/product.dart';
import 'package:furniture_ecommerce_app/features/products/domain/repositories/product_repository.dart';
import 'package:furniture_ecommerce_app/features/products/domain/use_cases/get_products_params.dart';

class GetProductsUseCase implements UseCase<List<Product>, GetProductsParams> {
  final ProductRepository productRepository;

  GetProductsUseCase(this.productRepository);

  @override
  ResultFuture<List<Product>> call(GetProductsParams params) async {
    return await productRepository.getProducts(params);
  }
}

