import 'package:furniture_ecommerce_app/core/utils/typedef.dart';
import 'package:furniture_ecommerce_app/features/products/domain/entities/product_details.dart';
import 'package:furniture_ecommerce_app/features/products/domain/repositories/product_repository.dart';

class GetProductDetailsUseCase {
  final ProductRepository productRepository;

  GetProductDetailsUseCase(this.productRepository);

  ResultFuture<ProductDetails> call(int productId) async {
    return productRepository.getProductDetails(productId);
  }
}
