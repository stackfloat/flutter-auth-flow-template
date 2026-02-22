import 'package:furniture_ecommerce_app/core/utils/typedef.dart';
import 'package:furniture_ecommerce_app/features/cart/domain/entities/cart_data.dart';
import 'package:furniture_ecommerce_app/features/cart/domain/repositories/cart_repository.dart';

class UpdateCartItemUseCase {
  final CartRepository cartRepository;

  UpdateCartItemUseCase(this.cartRepository);

  ResultFuture<CartData> call({
    required int cartItemId,
    required int quantity,
  }) {
    return cartRepository.updateCartItem(
      cartItemId: cartItemId,
      quantity: quantity,
    );
  }
}
