import 'package:furniture_ecommerce_app/core/utils/typedef.dart';
import 'package:furniture_ecommerce_app/features/checkout/domain/entities/order.dart';

abstract class OrderRepository {
  ResultFuture<Order> placeOrder({required int addressId});
  ResultFuture<void> verifyPayment({
    required int orderId,
    required String razorpayPaymentId,
    required String razorpayOrderId,
    required String razorpaySignature,
  });
}
