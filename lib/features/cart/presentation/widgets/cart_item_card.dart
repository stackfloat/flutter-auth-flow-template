import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:furniture_ecommerce_app/core/theme/app_colors.dart';
import 'package:furniture_ecommerce_app/features/cart/presentation/widgets/quantity_stepper.dart';

class CartItemCard extends StatelessWidget {
  final String title;
  final double price;
  final String colorName;
  final Color color;
  final int quantity;
  final String imagePath;
  final VoidCallback onDelete;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  const CartItemCard({
    super.key,
    required this.title,
    required this.price,
    required this.colorName,
    required this.color,
    required this.quantity,
    required this.imagePath,
    required this.onDelete,
    required this.onDecrease,
    required this.onIncrease,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6.r),
            child: Image.asset(
              imagePath,
              width: 58.w,
              height: 58.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.lightText,
                  ),
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Text(
                      '\$${price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.lightTextSecondary,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      colorName,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          QuantityStepper(
            quantity: quantity,
            onDecrease: onDecrease,
            onIncrease: onIncrease,
          ),
          SizedBox(width: 8.w),
          Material(
            color: Colors.black,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onDelete,
              child: SizedBox(
                width: 34.w,
                height: 34.w,
                child: Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 18.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
