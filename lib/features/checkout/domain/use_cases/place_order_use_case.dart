import 'package:furniture_ecommerce_app/core/utils/typedef.dart';
import 'package:furniture_ecommerce_app/features/checkout/domain/entities/order.dart';
import 'package:furniture_ecommerce_app/features/checkout/domain/repositories/order_repository.dart';

class PlaceOrderUseCase {
  final OrderRepository repository;

  PlaceOrderUseCase(this.repository);

  ResultFuture<Order> call({required int addressId}) =>
      repository.placeOrder(addressId: addressId);
}
