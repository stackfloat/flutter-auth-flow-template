import 'package:equatable/equatable.dart';

class OrderPaymentInfo extends Equatable {
  final String razorpayOrderId;
  final int amountPaise;
  final String razorpayKeyId;

  const OrderPaymentInfo({
    required this.razorpayOrderId,
    required this.amountPaise,
    required this.razorpayKeyId,
  });

  @override
  List<Object?> get props => [razorpayOrderId, amountPaise, razorpayKeyId];
}

class Order extends Equatable {
  final int id;
  final String orderNumber;
  final String status;
  final double subtotal;
  final double shippingFee;
  final double total;
  final String createdAt;
  final OrderPaymentInfo? payment;

  const Order({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.subtotal,
    required this.shippingFee,
    required this.total,
    required this.createdAt,
    this.payment,
  });

  @override
  List<Object?> get props =>
      [id, orderNumber, status, subtotal, shippingFee, total, createdAt, payment];
}
