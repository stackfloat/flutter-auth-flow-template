import 'package:furniture_ecommerce_app/core/services/network/dio_client.dart';
import 'package:furniture_ecommerce_app/core/utils/typedef.dart';
import 'package:furniture_ecommerce_app/features/checkout/data/models/order_model.dart';

abstract class OrderRemoteDataSource {
  ResultFuture<OrderModel> placeOrder({required int addressId});
  ResultFuture<void> verifyPayment({
    required int orderId,
    required String razorpayPaymentId,
    required String razorpayOrderId,
    required String razorpaySignature,
  });
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final DioClient _dioClient;

  OrderRemoteDataSourceImpl(this._dioClient);

  @override
  ResultFuture<OrderModel> placeOrder({required int addressId}) {
    return _dioClient.post<OrderModel>(
      '/orders',
      data: {'address_id': addressId},
      parser: (data) {
        if (data is! Map<String, dynamic>) {
          throw const FormatException('Invalid order response');
        }
        return OrderModel.fromApiJson(data);
      },
    );
  }

  @override
  ResultFuture<void> verifyPayment({
    required int orderId,
    required String razorpayPaymentId,
    required String razorpayOrderId,
    required String razorpaySignature,
  }) {
    return _dioClient.post<void>(
      '/orders/$orderId/verify-payment',
      data: {
        'razorpay_payment_id': razorpayPaymentId,
        'razorpay_order_id': razorpayOrderId,
        'razorpay_signature': razorpaySignature,
      },
      parser: (_) => null,
    );
  }
}
