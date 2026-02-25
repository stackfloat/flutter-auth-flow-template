import 'package:furniture_ecommerce_app/core/utils/typedef.dart';
import 'package:furniture_ecommerce_app/features/checkout/data/datasources/order_remote_data_source.dart';
import 'package:furniture_ecommerce_app/features/checkout/domain/entities/order.dart';
import 'package:furniture_ecommerce_app/features/checkout/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl(this.remoteDataSource);

  @override
  ResultFuture<Order> placeOrder({required int addressId}) async {
    final result = await remoteDataSource.placeOrder(addressId: addressId);
    return result.map((order) => order);
  }

  @override
  ResultFuture<void> verifyPayment({
    required int orderId,
    required String razorpayPaymentId,
    required String razorpayOrderId,
    required String razorpaySignature,
  }) async {
    return remoteDataSource.verifyPayment(
      orderId: orderId,
      razorpayPaymentId: razorpayPaymentId,
      razorpayOrderId: razorpayOrderId,
      razorpaySignature: razorpaySignature,
    );
  }
}
