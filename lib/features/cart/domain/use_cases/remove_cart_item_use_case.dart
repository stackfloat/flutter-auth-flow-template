import 'package:furniture_ecommerce_app/core/utils/typedef.dart';
import 'package:furniture_ecommerce_app/features/cart/domain/entities/cart_data.dart';
import 'package:furniture_ecommerce_app/features/cart/domain/repositories/cart_repository.dart';

class RemoveCartItemUseCase {
  final CartRepository cartRepository;

  RemoveCartItemUseCase(this.cartRepository);

  ResultFuture<CartData> call({
    required int cartItemId,
  }) {
    return cartRepository.removeCartItem(cartItemId: cartItemId);
  }
}
