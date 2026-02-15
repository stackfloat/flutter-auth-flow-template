import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:furniture_ecommerce_app/core/theme/app_colors.dart';

class CartSummarySection extends StatelessWidget {
  final double subtotal;
  final double shippingFee;
  final double estimateTax;
  final double total;
  final VoidCallback onCheckout;

  const CartSummarySection({
    super.key,
    required this.subtotal,
    required this.shippingFee,
    required this.estimateTax,
    required this.total,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.black12, width: 0.8)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SummaryRow(label: 'Sub Total', value: _currency(subtotal)),
            SizedBox(height: 10.h),
            _SummaryRow(label: 'Shipping Fee', value: _currency(shippingFee)),
            SizedBox(height: 10.h),
            _SummaryRow(label: 'Estimating Tax', value: _currency(estimateTax)),
            SizedBox(height: 12.h),
            Divider(color: Colors.black26, height: 1.h),
            SizedBox(height: 12.h),
            _SummaryRow(label: 'Total', value: _currency(total), isTotal: true),
            SizedBox(height: 16.h),
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                onPressed: onCheckout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: Text(
                  'Checkout',
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _currency(double value) => '\$${value.toStringAsFixed(2)}';
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

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
