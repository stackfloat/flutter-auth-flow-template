import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:furniture_ecommerce_app/core/theme/app_colors.dart';
import 'package:furniture_ecommerce_app/core/theme/theme_extensions.dart';
import 'package:furniture_ecommerce_app/features/home/domain/entities/home_banner.dart';
import 'package:furniture_ecommerce_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:furniture_ecommerce_app/features/home/presentation/widgets/category_card.dart';
import 'package:furniture_ecommerce_app/features/home/presentation/widgets/header_basket_icon.dart';
import 'package:furniture_ecommerce_app/features/home/presentation/widgets/product_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading || state is HomeInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is HomeLoadingFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: context.typography.body,
                ),
              ),
            );
          }

          final loadedState = state as HomeLoaded;
          final categories = loadedState.data.categories;
          final products = loadedState.data.products;
          final banner = loadedState.data.banner;

          return SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 0,
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/logo.png',
                                width: 28.w,
                                height: 28.w,
                                fit: BoxFit.contain,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Smart Furniture Mart',
                                style: context.typography.pageTitle,
                              ),
                            ],
                          ),
                          const HeaderBasketIcon(),
                        ],
                      ),
                      SizedBox(height: 18.h),
                      _HomeBannerCard(
                        banner: banner,
                        onTap: () => context.pushNamed('products'),
                      ),
                      SizedBox(height: 22.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Categories',
                            style: context.typography.pageTitleMedium,
                          ),
                          GestureDetector(
                            onTap: () => context.pushNamed('categories'),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(999.r),
                                border: Border.all(
                                  color: AppColors.border.withValues(
                                    alpha: 0.5,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    'View all',
                                    style: context.typography.pageTitleSmall
                                        .copyWith(
                                          color: AppColors.lightTextSecondary,
                                        ),
                                  ),
                                  SizedBox(width: 4.w),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 14.sp,
                                    color: AppColors.lightTextSecondary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 14.h),
                      SizedBox(
                        width: double.infinity,
                        height: 94.h,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(width: 12.w),
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            return CategoryCard(
                              imageUrl: category.icon,
                              title: category.name,
                              productsCount: category.productsCount,
                              onTap: () => context.pushNamed(
                                'products-preview',
                                queryParameters: {
                                  'category_id': category.id.toString(),
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Latest',
                            style: context.typography.pageTitleMedium,
                          ),
                          GestureDetector(
                            onTap: () => context.goNamed('products'),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(999.r),
                                border: Border.all(
                                  color: AppColors.border.withValues(
                                    alpha: 0.5,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    'View all',
                                    style: context.typography.pageTitleSmall
                                        .copyWith(
                                          color: AppColors.lightTextSecondary,
                                        ),
                                  ),
                                  SizedBox(width: 4.w),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 14.sp,
                                    color: AppColors.lightTextSecondary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 14.h),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: products.length > 5 ? 5 : products.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 16.h),
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return ProductCard(
                            title: product.name,
                            price: product.price,
                            image: NetworkImage(product.photo),
                            onShopTap: () => context.pushNamed(
                              'product',
                              pathParameters: {'id': product.id.toString()},
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 18.h),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HomeBannerCard extends StatelessWidget {
  const _HomeBannerCard({required this.banner, required this.onTap});

  final HomeBanner? banner;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: SizedBox(
          width: double.infinity,
          height: 160.h,
          child: banner != null && banner!.imageUrl.isNotEmpty
              ? Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: banner!.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, _) => Container(
                        color: AppColors.border.withValues(alpha: 0.3),
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (_, _, _) => Container(
                        color: AppColors.border.withValues(alpha: 0.3),
                        child: const Icon(Icons.image_not_supported_outlined),
                      ),
                    ),
                    Positioned(
                      left: 16.w,
                      top: 16.h,
                      right: 16.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (banner!.title.isNotEmpty)
                            Text(
                              banner!.title,
                              style: context.typography.pageTitleMedium
                                  .copyWith(color: Colors.black),
                            ),
                          if (banner!.subTitle.isNotEmpty) ...[
                            SizedBox(height: 4.h),
                            Text(
                              banner!.subTitle,
                              style: context.typography.body.copyWith(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                )
              : Container(
                  color: AppColors.border.withValues(alpha: 0.3),
                  child: Center(
                    child: Text(
                      'View Products',
                      style: context.typography.body.copyWith(
                        color: AppColors.lightTextSecondary,
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
