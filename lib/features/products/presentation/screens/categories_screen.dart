import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:furniture_ecommerce_app/core/theme/app_colors.dart';
import 'package:furniture_ecommerce_app/core/theme/theme_extensions.dart';
import 'package:furniture_ecommerce_app/features/products/domain/entities/category_list_item.dart';
import 'package:furniture_ecommerce_app/features/products/presentation/bloc/categories_bloc.dart';
import 'package:go_router/go_router.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(centerTitle: true, title: const Text('Categories')),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: BlocBuilder<CategoriesBloc, CategoriesState>(
            builder: (context, state) {
              if (state is CategoriesLoading || state is CategoriesInitial) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is CategoriesFailure) {
                return Center(
                  child: Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: context.typography.body,
                  ),
                );
              }

              if (state is CategoriesLoaded) {
                return _CategoryListView(categories: state.categories);
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}

class _CategoryListView extends StatelessWidget {
  final List<CategoryListItem> categories;

  const _CategoryListView({required this.categories});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: categories.length,
      separatorBuilder: (_, _) => SizedBox(height: 14.h),
      itemBuilder: (context, index) {
        final category = categories[index];
        return _CategoryTile(
          category: category,
          onTap: () => context.goNamed(
            'products',
            queryParameters: {'category_id': category.id.toString()},
          ),
        );
      },
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final CategoryListItem category;
  final VoidCallback onTap;

  const _CategoryTile({
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(14.w),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Container(
                  width: 58.w,
                  height: 58.w,
                  color: AppColors.border.withValues(alpha: 0.35),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.chair_alt_rounded,
                    size: 28.sp,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${category.productsCount} Items',
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.lightTextSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                Icons.chevron_right_rounded,
                size: 26.sp,
                color: Colors.black87,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

