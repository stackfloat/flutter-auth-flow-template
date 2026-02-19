import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:furniture_ecommerce_app/core/theme/app_colors.dart';
import 'package:furniture_ecommerce_app/core/theme/theme_extensions.dart';

class ProductsCategoryList extends StatefulWidget {
  final List<String> categories;
  final ValueChanged<String>? onCategorySelected;

  const ProductsCategoryList({
    super.key,
    required this.categories,
    this.onCategorySelected,
  });

  @override
  State<ProductsCategoryList> createState() => _ProductsCategoryListState();
}

class _ProductsCategoryListState extends State<ProductsCategoryList> {
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.categories.first;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: widget.categories.length,
        separatorBuilder: (context, index) => SizedBox(width: 10.w),
        itemBuilder: (context, index) {
          final category = widget.categories[index];
          final isSelected = category == _selectedCategory;

          return InkWell(
            onTap: () {
              setState(() {
                _selectedCategory = category;
              });
              widget.onCategorySelected?.call(category);
            },
            borderRadius: BorderRadius.circular(10.r),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.lightText : Colors.white,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                category,
                style: context.typography.body.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.lightText,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
