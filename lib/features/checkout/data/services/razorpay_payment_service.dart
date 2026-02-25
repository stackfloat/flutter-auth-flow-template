import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

/// Wraps Razorpay Flutter SDK to expose a Future-based API for payment checkout.
class RazorpayPaymentService {
  Razorpay? _razorpay;
  Completer<PaymentSuccessResponse>? _successCompleter;
  Completer<String>? _failureCompleter;

  /// Opens Razorpay checkout and returns [PaymentSuccessResponse] on success.
  /// Throws [RazorpayPaymentException] with message on failure or user cancel.
  Future<PaymentSuccessResponse> openCheckout({
    required String keyId,
    required String orderId,
    required int amountPaise,
    String currency = 'INR',
    String name = 'Furniture Store',
    String? description,
  }) async {
    _successCompleter = Completer<PaymentSuccessResponse>();
    _failureCompleter = Completer<String>();

    _razorpay = Razorpay();
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    final options = {
      'key': keyId,
      'amount': amountPaise,
      'currency': currency,
      'name': name,
      'order_id': orderId,
      if (description != null) 'description': description,
    };

    try {
      _razorpay!.open(options);
      final result = await Future.any([
        _successCompleter!.future,
        _failureCompleter!.future.then((msg) => throw RazorpayPaymentException(msg)),
      ]);
      return result;
    } finally {
      _razorpay!.clear();
      _razorpay = null;
      _successCompleter = null;
      _failureCompleter = null;
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    if (!(_successCompleter?.isCompleted ?? true)) {
      _successCompleter!.complete(response);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    if (!(_failureCompleter?.isCompleted ?? true)) {
      final msg = response.message ?? 'Payment failed';
      _failureCompleter!.complete(msg);
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    if (!(_failureCompleter?.isCompleted ?? true)) {
      _failureCompleter!.complete(
        'External wallet selected: ${response.walletName ?? "Unknown"}',
      );
    }
  }
}

class RazorpayPaymentException implements Exception {
  final String message;

  RazorpayPaymentException(this.message);

  @override
  String toString() => message;
}
