import 'package:furniture_ecommerce_app/core/utils/typedef.dart';
import 'package:furniture_ecommerce_app/features/checkout/domain/repositories/order_repository.dart';

class VerifyPaymentUseCase {
  final OrderRepository repository;

  VerifyPaymentUseCase(this.repository);

  ResultFuture<void> call({
    required int orderId,
    required String razorpayPaymentId,
    required String razorpayOrderId,
    required String razorpaySignature,
  }) =>
      repository.verifyPayment(
        orderId: orderId,
        razorpayPaymentId: razorpayPaymentId,
        razorpayOrderId: razorpayOrderId,
        razorpaySignature: razorpaySignature,
      );
}
