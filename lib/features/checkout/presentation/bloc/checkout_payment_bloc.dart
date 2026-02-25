import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_ecommerce_app/core/errors/failure.dart';
import 'package:furniture_ecommerce_app/features/checkout/data/services/razorpay_payment_service.dart';
import 'package:furniture_ecommerce_app/features/checkout/domain/entities/order.dart';
import 'package:furniture_ecommerce_app/features/checkout/domain/use_cases/place_order_use_case.dart';
import 'package:furniture_ecommerce_app/features/checkout/domain/use_cases/verify_payment_use_case.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

part 'checkout_payment_event.dart';
part 'checkout_payment_state.dart';

class CheckoutPaymentBloc
    extends Bloc<CheckoutPaymentEvent, CheckoutPaymentState> {
  final PlaceOrderUseCase placeOrderUseCase;
  final VerifyPaymentUseCase verifyPaymentUseCase;
  final RazorpayPaymentService razorpayPaymentService;

  CheckoutPaymentBloc(
    this.placeOrderUseCase,
    this.verifyPaymentUseCase,
    this.razorpayPaymentService,
  ) : super(const CheckoutPaymentState()) {
    on<CheckoutPaymentRequested>(_onPaymentRequested);
  }

  Future<void> _onPaymentRequested(
    CheckoutPaymentRequested event,
    Emitter<CheckoutPaymentState> emit,
  ) async {
    emit(state.copyWith(status: CheckoutPaymentStatus.placingOrder));

    final orderResult = await placeOrderUseCase(addressId: event.addressId);
    await orderResult.fold(
      (failure) async {
        emit(state.copyWith(
          status: CheckoutPaymentStatus.failure,
          errorMessage: _mapFailureToMessage(failure),
        ));
      },
      (order) async {
        final payment = order.payment;
        if (payment == null) {
          emit(state.copyWith(
            status: CheckoutPaymentStatus.failure,
            errorMessage: 'Order created but payment info is missing.',
          ));
          return;
        }

        emit(state.copyWith(
          status: CheckoutPaymentStatus.awaitingPayment,
          order: order,
        ));

        try {
          final successResponse = await razorpayPaymentService.openCheckout(
            keyId: payment.razorpayKeyId,
            orderId: payment.razorpayOrderId,
            amountPaise: payment.amountPaise,
          );

          emit(state.copyWith(status: CheckoutPaymentStatus.verifying));

          final verifyResult = await verifyPaymentUseCase(
            orderId: order.id,
            razorpayPaymentId: successResponse.paymentId ?? '',
            razorpayOrderId: successResponse.orderId ?? '',
            razorpaySignature: successResponse.signature ?? '',
          );

          verifyResult.fold(
            (failure) => emit(state.copyWith(
              status: CheckoutPaymentStatus.failure,
              errorMessage: _mapFailureToMessage(failure),
            )),
            (_) => emit(state.copyWith(
              status: CheckoutPaymentStatus.success,
              order: order,
            )),
          );
        } on RazorpayPaymentException catch (e) {
          emit(state.copyWith(
            status: CheckoutPaymentStatus.failure,
            errorMessage: e.message,
          ));
        }
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is NetworkFailure) {
      return failure.message ?? 'Network error. Please try again.';
    }
    if (failure is ServerFailure) {
      return failure.message ?? 'Something went wrong. Please try again.';
    }
    if (failure is ApiFailure) {
      return failure.message ?? 'Something went wrong. Please try again.';
    }
    return failure.message ?? 'An unexpected error occurred.';
  }
}
