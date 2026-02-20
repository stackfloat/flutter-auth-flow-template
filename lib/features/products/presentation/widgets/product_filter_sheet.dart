import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:furniture_ecommerce_app/core/theme/app_colors.dart';
import 'package:furniture_ecommerce_app/core/theme/theme_extensions.dart';
import 'package:furniture_ecommerce_app/features/products/domain/entities/category.dart';

class ProductFilterSheet extends StatefulWidget {
  final List<Category> categories;
  final String selectedCategoryId;
  final ValueChanged<Category>? onCategorySelected;

  const ProductFilterSheet({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    this.onCategorySelected,
  });

  @override
  State<ProductFilterSheet> createState() => _ProductFilterSheetState();
}

class _ProductFilterSheetState extends State<ProductFilterSheet> {
  String _sortBy = 'Recommended';
  String _selectedMaterial = 'Wooden';
  late String _selectedCategoryId;
  int _selectedColor = 4;
  RangeValues _priceRange = const RangeValues(10, 200);

  static const _sortOptions = [
    'Recommended',
    'Price: Low to High',
    'Price: High to Low',
    'Newest',
  ];

  static const _materialOptions = [
    'Canvas',
    'Wooden',
    'Leather',
    'Linen',
    'Tweed',
    'Velvet',
    'Metal',
    'Rattan',
    'Bamboo',
    'Marble',
    'Glass',
    'Wicker',
    'Fabric',
    'Engineered Wood',
    'Solid Oak',
    'Steel',
  ];

  static const _colorOptions = [
    Color(0xFFFE2A2A),
    Color(0xFF274BA0),
    Color(0xFFD09052),
    Color(0xFF6761D8),
    Color(0xFF000000),
    Color(0xFFBFBFBF),
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategoryId =
        widget.selectedCategoryId.isEmpty ? '0' : widget.selectedCategoryId;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 24.h),
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 44.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(999.r),
              ),
            ),
          ),
          SizedBox(height: 18.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Filter',
                  style: context.typography.pageTitleMedium.copyWith(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.lightText,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.close_rounded, size: 24.sp),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionLabel(text: 'Sort By'),
                  SizedBox(height: 8.h),
                  PopupMenuButton<String>(
                    onSelected: (value) => setState(() => _sortBy = value),
                    itemBuilder: (context) => _sortOptions
                        .map(
                          (option) => PopupMenuItem<String>(
                            value: option,
                            child: Text(option),
                          ),
                        )
                        .toList(),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: AppColors.border),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _sortBy,
                              style: context.typography.body.copyWith(
                                fontSize: 15.sp,
                                color: AppColors.lightText,
                              ),
                            ),
                          ),
                          Icon(Icons.keyboard_arrow_down_rounded, size: 22.sp),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  _SectionLabel(text: 'Material'),
                  SizedBox(height: 10.h),
                  Wrap(
                    spacing: 10.w,
                    runSpacing: 10.h,
                    children: _materialOptions.map((material) {
                      final isSelected = _selectedMaterial == material;
                      return _FilterChip(
                        label: material,
                        isSelected: isSelected,
                        onTap: () => setState(() => _selectedMaterial = material),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20.h),
                  _SectionLabel(text: 'Categories'),
                  SizedBox(height: 10.h),
                  if (widget.categories.isEmpty)
                    Text(
                      'No categories available',
                      style: context.typography.body.copyWith(
                        fontSize: 14.sp,
                        color: AppColors.lightText.withValues(alpha: 0.7),
                      ),
                    )
                  else
                    Wrap(
                      spacing: 10.w,
                      runSpacing: 10.h,
                      children: widget.categories.map((category) {
                        final categoryId = category.id.toString();
                        final isSelected = _selectedCategoryId == categoryId;
                        return _FilterChip(
                          label: category.name,
                          isSelected: isSelected,
                          onTap: () {
                            setState(() => _selectedCategoryId = categoryId);
                            widget.onCategorySelected?.call(category);
                          },
                        );
                      }).toList(),
                    ),
                  SizedBox(height: 20.h),
                  _SectionLabel(text: 'Colors'),
                  SizedBox(height: 10.h),
                  Wrap(
                    spacing: 14.w,
                    runSpacing: 10.h,
                    children: List.generate(_colorOptions.length, (index) {
                      final color = _colorOptions[index];
                      final isSelected = _selectedColor == index;
                      return InkWell(
                        onTap: () => setState(() => _selectedColor = index),
                        borderRadius: BorderRadius.circular(999.r),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: 28.w,
                          height: 28.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: color,
                            border: Border.all(
                              color: isSelected ? AppColors.lightText : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 20.h),
                  _SectionLabel(text: 'Price'),
                  SizedBox(height: 8.h),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 4.h,
                      activeTrackColor: Colors.black,
                      inactiveTrackColor: AppColors.border.withValues(alpha: 0.7),
                      thumbColor: Colors.black,
                      overlayShape: SliderComponentShape.noOverlay,
                    ),
                    child: RangeSlider(
                      values: _priceRange,
                      min: 0,
                      max: 400,
                      divisions: 40,
                      onChanged: (value) => setState(() => _priceRange = value),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '\$${_priceRange.start.round()}',
                            style: context.typography.body.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                        Text(
                          '\$${_priceRange.end.round()}',
                          style: context.typography.body.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            height: 54.h,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                'Apply',
                style: context.typography.button.copyWith(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: context.typography.pageTitleMedium.copyWith(
        color: AppColors.lightText,
        fontSize: 24.sp,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected ? Colors.black : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: context.typography.body.copyWith(
            color: isSelected ? Colors.white : AppColors.lightText,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
