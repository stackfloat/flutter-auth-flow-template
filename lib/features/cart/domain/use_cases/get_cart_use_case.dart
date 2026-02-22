import 'package:furniture_ecommerce_app/core/utils/typedef.dart';
import 'package:furniture_ecommerce_app/features/cart/domain/entities/cart_data.dart';
import 'package:furniture_ecommerce_app/features/cart/domain/repositories/cart_repository.dart';

class GetCartUseCase {
  final CartRepository cartRepository;

  GetCartUseCase(this.cartRepository);

  ResultFuture<CartData> call() {
    return cartRepository.getCart();
  }
}
