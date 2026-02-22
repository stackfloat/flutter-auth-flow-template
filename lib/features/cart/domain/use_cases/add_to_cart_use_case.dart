import 'package:furniture_ecommerce_app/core/utils/typedef.dart';
import 'package:furniture_ecommerce_app/features/cart/domain/repositories/cart_repository.dart';

class AddToCartUseCase {
  final CartRepository cartRepository;

  AddToCartUseCase(this.cartRepository);

  ResultFuture<void> call({
    required int productId,
    required int quantity,
  }) {
    return cartRepository.addToCart(
      productId: productId,
      quantity: quantity,
    );
  }
}
