import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:furniture_ecommerce_app/core/theme/app_colors.dart';
import 'package:furniture_ecommerce_app/features/cart/domain/entities/cart_data.dart';
import 'package:furniture_ecommerce_app/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:furniture_ecommerce_app/features/cart/presentation/widgets/cart_item_card.dart';
import 'package:furniture_ecommerce_app/features/cart/presentation/widgets/cart_summary_section.dart';
import 'package:go_router/go_router.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Cart'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          final cartData = _resolveData(state);
          final items = cartData.items;
          final isInitialLoading =
              state is CartLoading && state.previousData.items.isEmpty;

          if (isInitialLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CartLoadingFailure && items.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  state.message,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: items.isEmpty
                    ? Center(
                        child: Text(
                          'Your cart is empty',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: AppColors.lightTextSecondary,
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 20.h),
                        itemCount: items.length,
                        separatorBuilder: (_, _) => SizedBox(height: 12.h),
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return CartItemCard(
                            title: item.product.name,
                            price: item.product.price,
                            quantity: item.quantity,
                            imagePath: item.product.photo,
                            onDelete: () => context.read<CartBloc>().add(
                              RemoveCartItemEvent(cartItemId: item.id),
                            ),
                            onDecrease: () {
                              if (item.quantity <= 1) return;
                              context.read<CartBloc>().add(
                                UpdateCartItemEvent(
                                  cartItemId: item.id,
                                  quantity: item.quantity - 1,
                                ),
                              );
                            },
                            onIncrease: () => context.read<CartBloc>().add(
                              UpdateCartItemEvent(
                                cartItemId: item.id,
                                quantity: item.quantity + 1,
                              ),
                            ),
                          );
                        },
                      ),
              ),
              CartSummarySection(
                subTotal: cartData.subTotal,
                shippingFee: cartData.shippingFee,
                total: cartData.totalPrice,
                onCheckout: () {
                  context.pushNamed('choose-address');
                },
              ),
            ],
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
