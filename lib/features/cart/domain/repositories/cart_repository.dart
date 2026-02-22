import 'package:furniture_ecommerce_app/core/utils/typedef.dart';
import 'package:furniture_ecommerce_app/features/cart/domain/entities/cart_data.dart';

abstract class CartRepository {
  ResultFuture<void> addToCart({
    required int productId,
    required int quantity,
  });

  ResultFuture<CartData> getCart();

  ResultFuture<CartData> updateCartItem({
    required int cartItemId,
    required int quantity,
  });

  ResultFuture<CartData> removeCartItem({
    required int cartItemId,
  });
}
