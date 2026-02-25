part of 'checkout_payment_bloc.dart';

sealed class CheckoutPaymentEvent extends Equatable {
  const CheckoutPaymentEvent();

  @override
  List<Object?> get props => [];
}

final class CheckoutPaymentRequested extends CheckoutPaymentEvent {
  final int addressId;

  const CheckoutPaymentRequested({required this.addressId});

  @override
  List<Object?> get props => [addressId];
}
