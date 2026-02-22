import 'package:furniture_ecommerce_app/core/utils/typedef.dart';
import 'package:furniture_ecommerce_app/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:furniture_ecommerce_app/features/cart/domain/entities/cart_data.dart';
import 'package:furniture_ecommerce_app/features/cart/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource cartRemoteDataSource;

  CartRepositoryImpl(this.cartRemoteDataSource);

  @override
  ResultFuture<void> addToCart({
    required int productId,
    required int quantity,
  }) {
    return cartRemoteDataSource.addToCart(
      productId: productId,
      quantity: quantity,
    );
  }

  @override
  ResultFuture<CartData> getCart() async {
    final result = await cartRemoteDataSource.getCart();
    return result.map((data) => data);
  }

  @override
  ResultFuture<CartData> removeCartItem({
    required int cartItemId,
  }) async {
    final result = await cartRemoteDataSource.removeCartItem(
      cartItemId: cartItemId,
    );
    return result.map((data) => data);
  }

  @override
  ResultFuture<CartData> updateCartItem({
    required int cartItemId,
    required int quantity,
  }) async {
    final result = await cartRemoteDataSource.updateCartItem(
      cartItemId: cartItemId,
      quantity: quantity,
    );
    return result.map((data) => data);
  }
}
