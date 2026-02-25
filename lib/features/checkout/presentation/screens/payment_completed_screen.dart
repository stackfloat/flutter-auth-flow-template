import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:furniture_ecommerce_app/core/common/widgets/elevated_button_widget.dart';
import 'package:furniture_ecommerce_app/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

class PaymentCompletedScreen extends StatelessWidget {
  const PaymentCompletedScreen({super.key, this.orderNumber});

  final String? orderNumber;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 20.h),
          child: Column(
            children: [
              const Spacer(flex: 2),
              const _CompletedMark(),
              SizedBox(height: 20.h),
              Text(
                'Thank You!',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 14.h),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 280.w),
                child: Text.rich(
                  TextSpan(
                    style: textTheme.bodyLarge?.copyWith(
                      color: Colors.black87,
                      height: 1.45,
                    ),
                    children: [
                      const TextSpan(text: 'Your Order '),
                      TextSpan(
                        text: orderNumber ?? '—',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const TextSpan(text: ' is Completed.\n'),
                      TextSpan(text: 'Please Check the Delivery Status at '),
                      TextSpan(
                        text: 'Order Tracking',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(text: ' Pages.'),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(flex: 3),
              SizedBox(
                width: double.infinity,
                child: ElevatedButtonWidget(
                  buttonLabel: 'Continue Shopping',
                  onPressEvent: () {
                    context.goNamed('products');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompletedMark extends StatelessWidget {
  const _CompletedMark();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 132.w,
      height: 132.w,
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _OpenCirclePainter(
                strokeColor: Colors.black,
                strokeWidth: 6.w,
              ),
            ),
          ),
          Center(
            child: Icon(
              Icons.check_rounded,
              size: 62.w,
              color: Colors.black,
              weight: 900,
            ),
          ),
        ],
      ),
    );
  }
}

class _OpenCirclePainter extends CustomPainter {
  final Color strokeColor;
  final double strokeWidth;

  const _OpenCirclePainter({
    required this.strokeColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide - strokeWidth) / 2;
    const startAngle = 0.2;
    const sweepAngle = 5.7;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _OpenCirclePainter oldDelegate) {
    return strokeColor != oldDelegate.strokeColor ||
        strokeWidth != oldDelegate.strokeWidth;
  }
}
