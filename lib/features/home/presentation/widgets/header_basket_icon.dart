import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:furniture_ecommerce_app/core/theme/app_colors.dart';
import 'package:furniture_ecommerce_app/features/cart/domain/entities/cart_data.dart';
import 'package:furniture_ecommerce_app/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:go_router/go_router.dart';

class HeaderBasketIcon extends StatelessWidget {
  const HeaderBasketIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        final cartData = _resolveData(state);
        final count = cartData.items.fold<int>(
          0,
          (sum, item) => sum + item.quantity,
        );

        return GestureDetector(
          onTap: () => context.pushNamed('cart-preview'),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                Icons.shopping_cart,
                size: 26.w,
                color: AppColors.lightText,
              ),
              if (count > 0)
                Positioned(
                  top: -4.h,
                  right: -6.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: count > 99 ? 4.w : 5.w,
                      vertical: 2.h,
                    ),
                    constraints: BoxConstraints(minWidth: 16.w, minHeight: 16.w),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 219, 146, 146),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      count > 99 ? '99+' : count.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
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
