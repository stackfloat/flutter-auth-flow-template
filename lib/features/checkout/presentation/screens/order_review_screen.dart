import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:furniture_ecommerce_app/core/common/widgets/elevated_button_widget.dart';
import 'package:furniture_ecommerce_app/core/theme/app_colors.dart';
import 'package:furniture_ecommerce_app/features/cart/domain/entities/cart_data.dart';
import 'package:furniture_ecommerce_app/features/cart/domain/entities/cart_item.dart';
import 'package:furniture_ecommerce_app/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:furniture_ecommerce_app/features/checkout/domain/entities/address.dart';
import 'package:furniture_ecommerce_app/features/checkout/presentation/bloc/checkout_payment_bloc.dart';
import 'package:go_router/go_router.dart';

class OrderReviewScreen extends StatelessWidget {
  const OrderReviewScreen({
    super.key,
    required this.selectedAddress,
  });

  final Address selectedAddress;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Order Review'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: BlocConsumer<CheckoutPaymentBloc, CheckoutPaymentState>(
        listenWhen: (prev, curr) =>
            prev.status != curr.status &&
            curr.status == CheckoutPaymentStatus.success,
        listener: (context, state) {
          context.read<CartBloc>().add(const GetCartEvent());
          context.pushReplacementNamed(
            'payment-completed',
            extra: state.order?.orderNumber,
          );
        },
        builder: (context, paymentState) {
          return BlocBuilder<CartBloc, CartState>(
            builder: (context, cartState) {
              final cartData = _resolveData(cartState);
              final items = cartData.items;

              if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Your cart is empty',
                    style: textTheme.bodyLarge?.copyWith(
                      color: AppColors.lightTextSecondary,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: const Text('Go back'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 20.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Products',
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      _ProductList(items: items),
                      SizedBox(height: 24.h),
                      Text(
                        'Shipping Address',
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      _AddressCard(address: selectedAddress),
                      SizedBox(height: 24.h),
                      _OrderSummary(
                        subTotal: cartData.subTotal,
                        shippingFee: cartData.shippingFee,
                        total: cartData.totalPrice,
                      ),
                    ],
                  ),
                ),
              ),
              if (paymentState.status == CheckoutPaymentStatus.failure)
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 8.h),
                  child: Text(
                    paymentState.errorMessage ?? 'Payment failed',
                    style: textTheme.bodyMedium?.copyWith(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 16.h),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButtonWidget(
                      buttonLabel: 'Pay Now',
                      isLoading: paymentState.status ==
                              CheckoutPaymentStatus.placingOrder ||
                          paymentState.status ==
                              CheckoutPaymentStatus.awaitingPayment ||
                          paymentState.status ==
                              CheckoutPaymentStatus.verifying,
                      onPressEvent: () {
                        context.read<CheckoutPaymentBloc>().add(
                              CheckoutPaymentRequested(
                                addressId: selectedAddress.id,
                              ),
                            );
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
            },
          );
        },
      ),
    );
  }

  CartData _resolveData(CartState state) {
    if (state is CartLoaded) return state.data;
    if (state is CartLoading) return state.previousData;
    if (state is CartLoadingFailure) return state.previousData;
    if (state is CartAddToCartInProgress) return state.previousData;
    if (state is CartAddToCartSuccess) return state.previousData;
    if (state is CartAddToCartFailure) return state.previousData;
    return const CartData();
  }
}

class _ProductList extends StatelessWidget {
  const _ProductList({required this.items});

  final List<CartItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            _ProductRow(item: items[i]),
            if (i < items.length - 1)
              Divider(
                height: 1,
                indent: 16.w,
                endIndent: 16.w,
                color: AppColors.border.withValues(alpha: 0.5),
              ),
          ],
        ],
      ),
    );
  }
}

class _ProductRow extends StatelessWidget {
  const _ProductRow({required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    final lineTotal = item.product.price * item.quantity;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.lightText,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Qty: ${item.quantity} × \$${item.product.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '\$${lineTotal.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.lightText,
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({required this.address});

  final Address address;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            address.name,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.lightText,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            address.formattedAddress,
            style: TextStyle(
              fontSize: 13.sp,
              height: 1.3,
              color: AppColors.lightTextSecondary,
            ),
          ),
          if (address.phone.isNotEmpty) ...[
            SizedBox(height: 6.h),
            Text(
              address.phone,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.lightTextSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  const _OrderSummary({
    required this.subTotal,
    required this.shippingFee,
    required this.total,
  });

  final double subTotal;
  final double shippingFee;
  final double total;

  static String _currency(double value) =>
      '\$${value.toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _SummaryRow(label: 'Sub Total', value: _currency(subTotal)),
          SizedBox(height: 10.h),
          _SummaryRow(label: 'Shipping Fee', value: _currency(shippingFee)),
          SizedBox(height: 12.h),
          Divider(color: Colors.black26, height: 1.h),
          SizedBox(height: 12.h),
          _SummaryRow(label: 'Total', value: _currency(total), isTotal: true),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  final String label;
  final String value;
  final bool isTotal;

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 13.sp,
      fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
      color: AppColors.lightText,
    );

    return Row(
      children: [
        SizedBox(
          width: 90.w,
          child: Text(label, style: textStyle),
        ),
        SizedBox(
          width: 12.w,
          child: Text(':', textAlign: TextAlign.center, style: textStyle),
        ),
        Expanded(
          child: Text(value, textAlign: TextAlign.right, style: textStyle),
        ),
      ],
    );
  }
}
