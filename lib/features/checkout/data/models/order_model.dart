import 'package:furniture_ecommerce_app/features/checkout/domain/entities/order.dart';

class OrderModel extends Order {
  const OrderModel({
    required super.id,
    required super.orderNumber,
    required super.status,
    required super.subtotal,
    required super.shippingFee,
    required super.total,
    required super.createdAt,
    super.payment,
  });

  factory OrderModel.fromApiJson(Map<String, dynamic> json) {
    final payload = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    double parseDouble(Object? value, {double fallback = 0}) {
      if (value is double) return value;
      if (value is num) return value.toDouble();
      return double.tryParse(value?.toString() ?? '') ?? fallback;
    }

    OrderPaymentInfo? payment;
    final paymentData = payload['payment'];
    if (paymentData is Map<String, dynamic>) {
      payment = OrderPaymentInfo(
        razorpayOrderId:
            paymentData['razorpay_order_id']?.toString() ?? '',
        amountPaise: int.tryParse(
                paymentData['amount_paise']?.toString() ?? '') ??
            0,
        razorpayKeyId:
            paymentData['razorpay_key_id']?.toString() ?? '',
      );
    }

    return OrderModel(
      id: int.tryParse(payload['id']?.toString() ?? '') ?? 0,
      orderNumber: payload['order_number']?.toString() ?? '',
      status: payload['status']?.toString() ?? 'pending',
      subtotal: parseDouble(payload['subtotal']),
      shippingFee: parseDouble(payload['shipping_fee']),
      total: parseDouble(payload['total']),
      createdAt: payload['created_at']?.toString() ?? '',
      payment: payment,
    );
  }
}
