part of 'checkout_payment_bloc.dart';

enum CheckoutPaymentStatus {
  initial,
  placingOrder,
  awaitingPayment,
  verifying,
  success,
  failure,
}

class CheckoutPaymentState extends Equatable {
  final CheckoutPaymentStatus status;
  final Order? order;
  final String? errorMessage;

  const CheckoutPaymentState({
    this.status = CheckoutPaymentStatus.initial,
    this.order,
    this.errorMessage,
  });

  CheckoutPaymentState copyWith({
    CheckoutPaymentStatus? status,
    Order? order,
    Object? errorMessage = _unset,
  }) {
    return CheckoutPaymentState(
      status: status ?? this.status,
      order: order ?? this.order,
      errorMessage: errorMessage == _unset ? this.errorMessage : errorMessage as String?,
    );
  }

  static const _unset = Object();

  @override
  List<Object?> get props => [status, order, errorMessage];
}
