import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:furniture_ecommerce_app/core/theme/app_colors.dart';

class ProductScreen extends StatelessWidget {
  final String productId;
  const ProductScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ProductHero(
                    imagePath: 'assets/images/products/product_6.png',
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Casey 1 seater Manual Recliner in Brown Colour',
                          style: TextStyle(
                            fontSize: 26.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.lightText,
                            height: 1.15,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          '\$49.00',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.lightText,
                          ),
                        ),
                        SizedBox(height: 14.h),
                        Divider(color: Colors.black12, height: 1.h),
                        SizedBox(height: 14.h),
                        Text(
                          'Colors',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.lightText,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        const _ColorOptionsRow(),
                        SizedBox(height: 14.h),
                        Divider(color: Colors.black12, height: 1.h),
                        SizedBox(height: 14.h),
                        Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.lightText,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Design is an evolutionary process, and filler text is just one tool in your progress-pushing arsenal. Relax and do whatever fits with your design process. Don\'t set a lot of restrictive hard-and-fast rules distract designers and design.',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.lightTextSecondary,
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        _InfoRow(
                          label: 'Categories',
                          value: 'Furnitures, Accessories',
                        ),
                        SizedBox(height: 8.h),
                        _InfoRow(
                          label: 'Tags',
                          value: '#Furnitures, #Chair, #Table',
                        ),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const _BottomActionBar(),
        ],
      ),
    );
  }
}

class _ProductHero extends StatelessWidget {
  final String imagePath;

  const _ProductHero({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;

    return SizedBox(
      height: 440.h,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              imagePath,
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
              filterQuality: FilterQuality.high,
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.22),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.16),
                    ],
                    stops: const [0, 0.55, 1],
                  ),
                ),
              ),
            ),
            Positioned(
              top: topInset + 8.h,
              left: 10.w,
              child: Material(
                color: Colors.white,
                shape: const CircleBorder(),
                elevation: 1,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => Navigator.of(context).maybePop(),
                  child: SizedBox(
                    width: 38.w,
                    height: 38.w,
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.black87,
                      size: 18.sp,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: topInset + 8.h,
              right: 10.w,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.favorite_rounded),
                color: Colors.redAccent,
                iconSize: 24.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorOptionsRow extends StatelessWidget {
  const _ColorOptionsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ColorDot(color: const Color(0xFF805A50)),
        SizedBox(width: 12.w),
        _ColorDot(color: const Color(0xFF304A9E)),
        SizedBox(width: 12.w),
        _ColorDot(
          color: Colors.white,
          borderColor: const Color(0xFFCD8F48),
          borderWidth: 2,
        ),
        SizedBox(width: 12.w),
        _ColorDot(color: const Color(0xFFE5E8EA)),
        SizedBox(width: 12.w),
        _ColorDot(color: const Color(0xFF022D40)),
      ],
    );
  }
}

class _ColorDot extends StatelessWidget {
  final Color color;
  final Color? borderColor;
  final double borderWidth;

  const _ColorDot({
    required this.color,
    this.borderColor,
    this.borderWidth = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24.w,
      height: 24.w,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: borderColor == null
            ? null
            : Border.all(color: borderColor!, width: borderWidth),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 95.w,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.lightText,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          ':',
          style: TextStyle(
            fontSize: 13.sp,
            color: AppColors.lightTextSecondary,
          ),
        ),
        SizedBox(width: 18.w),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.lightText,
              fontWeight: FontWeight.w700,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}

class _BottomActionBar extends StatefulWidget {
  const _BottomActionBar();

  @override
  State<_BottomActionBar> createState() => _BottomActionBarState();
}

class _BottomActionBarState extends State<_BottomActionBar> {
  int _selectedQuantity = 1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 16.h),
        color: AppColors.lightBackground,
        child: Row(
          children: [
            Container(
              width: 72.w,
              height: 50.h,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black87, width: 1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: PopupMenuButton<int>(
                tooltip: '',
                initialValue: _selectedQuantity,
                padding: EdgeInsets.zero,
                position: PopupMenuPosition.under,
                onSelected: (value) => setState(() => _selectedQuantity = value),
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 1, child: Text('01')),
                  PopupMenuItem(value: 2, child: Text('02')),
                  PopupMenuItem(value: 3, child: Text('03')),
                  PopupMenuItem(value: 4, child: Text('04')),
                  PopupMenuItem(value: 5, child: Text('05')),
                ],
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      _selectedQuantity.toString().padLeft(2, '0'),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.lightText,
                      ),
                    ),
                    Positioned(
                      right: 6.w,
                      child: Icon(
                        Icons.unfold_more_rounded,
                        size: 16.sp,
                        color: AppColors.lightText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: SizedBox(
                height: 50.h,
                child: ElevatedButton.icon(
                  onPressed: () => context.pushNamed('cart-preview'),
                  icon: Icon(Icons.shopping_cart_outlined, size: 20.sp),
                  label: Text(
                    'Add to Cart',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
