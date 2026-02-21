import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:furniture_ecommerce_app/core/theme/theme_extensions.dart';
import 'package:go_router/go_router.dart';
import 'package:furniture_ecommerce_app/core/theme/app_colors.dart';
import 'package:furniture_ecommerce_app/features/products/domain/entities/category.dart';
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
      body: BlocBuilder<ProductsBloc, ProductsState>(
        builder: (context, state) {
          if (state is ProductsLoadingFailure) {
            return CustomScrollView(
              slivers: [
                _buildSliverAppBar(context),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: context.typography.body,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          final loadedState = state is ProductsLoaded ? state : null;
          final loadingState = state is ProductsLoading ? state : null;

          final rawCategories = loadedState?.categories ?? loadingState?.categories ?? const <Category>[];
          final categories = rawCategories.isEmpty
              ? const [Category(id: 0, name: 'All')]
              : [const Category(id: 0, name: 'All'), ...rawCategories];

          final selectedCategoryIdRaw =
              loadedState?.selectedCategoryId ?? loadingState?.selectedCategoryId ?? '';
          final selectedCategoryId =
              selectedCategoryIdRaw.isEmpty ? '0' : selectedCategoryIdRaw;

          return NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (loadedState == null || loadedState.isLoadingMore || !loadedState.hasMore) {
                return false;
              }
              final metrics = notification.metrics;
              final threshold = metrics.maxScrollExtent - 300;
              if (metrics.pixels >= threshold) {
                context.read<ProductsBloc>().add(const ProductsNextPageRequested());
              }
              return false;
            },
            child: CustomScrollView(
              slivers: [
                _buildSliverAppBar(context),
                _buildCategorySection(
                  context: context,
                  categories: categories,
                  selectedCategoryId: selectedCategoryId,
                ),
                if (loadedState != null)
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
                          final product = loadedState.products[index];
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
                        childCount: loadedState.products.length,
                      ),
                    ),
                  )
                else
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 24.h),
                        child: const CircularProgressIndicator(),
                      ),
                    ),
                  ),
                if (loadedState?.isLoadingMore ?? false)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: 16.h),
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                  ),
                SliverToBoxAdapter(
                  child: SizedBox(height: 16.h),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      snap: true,
      pinned: false,
      centerTitle: true,
      backgroundColor: AppColors.lightBackground,
      surfaceTintColor: AppColors.lightBackground,
      elevation: 0,
      scrolledUnderElevation: 0,
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
    );
  }

  SliverPadding _buildCategorySection({
    required BuildContext context,
    required List<Category> categories,
    required String selectedCategoryId,
  }) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0),
      sliver: SliverToBoxAdapter(
        child: ProductsCategoryList(
          categories: categories,
          selectedCategoryId: selectedCategoryId,
          onCategorySelected: (category) {
            context.read<ProductsBloc>().add(
                  ProductCategoryChanged(
                    categoryId: category.id == 0 ? '' : category.id.toString(),
                  ),
                );
          },
        ),
      ),
    );
  }

  void _openFilters(BuildContext context) {
    final productsBloc = context.read<ProductsBloc>();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: productsBloc,
        child: const ProductFilterSheet(),
      ),
    );
  }
}
