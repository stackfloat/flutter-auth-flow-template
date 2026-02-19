import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:furniture_ecommerce_app/core/theme/theme_extensions.dart';
import 'package:go_router/go_router.dart';
import 'package:furniture_ecommerce_app/core/theme/app_colors.dart';
import 'package:furniture_ecommerce_app/features/products/presentation/bloc/products_bloc.dart';
import 'package:furniture_ecommerce_app/features/products/presentation/widgets/product_filter_sheet.dart';
import 'package:furniture_ecommerce_app/features/products/presentation/widgets/product_grid_card.dart';
import 'package:furniture_ecommerce_app/features/products/presentation/widgets/products_category_list.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        title: Text(
          'Products',
          style: context.typography.pageTitle,
        ),
        actions: [
          IconButton(
            onPressed: () => _openFilters(context),
            icon: Icon(
              Icons.tune_rounded,
              size: 24.sp,
              color: AppColors.lightText,
            ),
          ),
        ],
      ),
      body: BlocBuilder<ProductsBloc, ProductsState>(
        builder: (context, state) {
          if (state is ProductsLoading || state is ProductsInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProductsLoadingFailure) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: context.typography.body,
                ),
              ),
            );
          }

          if (state is! ProductsLoaded) {
            return const SizedBox.shrink();
          }

          final categoryNames = state.categories.isEmpty
              ? const ['All']
              : state.categories.map((e) => e.name).toList();

          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0),
                sliver: SliverToBoxAdapter(
                  child: ProductsCategoryList(categories: categoryNames),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 0),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16.h,
                    crossAxisSpacing: 12.w,
                    childAspectRatio: 0.7,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = state.products[index];
                      return ProductGridCard(
                        title: product.name,
                        price: product.price,
                        imagePath: product.photo,
                        isFavorite: product.isFavorite,
                        onFavoriteTap: () {},
                        onTap: () => context.pushNamed(
                          'product',
                          pathParameters: {'id': product.id.toString()},
                        ),
                      );
                    },
                    childCount: state.products.length,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: 16.h),
              ),
            ],
          );
        },
      ),
    );
  }

  void _openFilters(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ProductFilterSheet(),
    );
  }
}
