import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:furniture_ecommerce_app/core/theme/theme_extensions.dart';
import 'package:furniture_ecommerce_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:furniture_ecommerce_app/features/home/presentation/widgets/category_card.dart';
import 'package:furniture_ecommerce_app/features/home/presentation/widgets/header_basket_icon.dart';
import 'package:furniture_ecommerce_app/features/home/presentation/widgets/product_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const categoryIcons = <IconData>[
      Icons.bed_rounded,
      Icons.table_restaurant_rounded,
      Icons.child_care_rounded,
      Icons.weekend_rounded,
      Icons.work_outline_rounded,
      Icons.deck_rounded,
    ];

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

          return SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 12.h,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Discover', style: context.typography.pageTitle),
                          const HeaderBasketIcon(),
                        ],
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16.r),
                        child: Image.asset(
                          'assets/images/home_banner.png',
                          width: double.infinity,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Categories',
                            style: context.typography.pageTitleMedium,
                          ),
                          GestureDetector(
                            onTap: () => context.pushNamed('categories'),
                            child: Text(
                              'VIEW ALL',
                              style: context.typography.pageTitleSmall,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 190.h,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          separatorBuilder: (context, index) => SizedBox(width: 12.w),
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            return CategoryCard(
                              icon: categoryIcons[index % categoryIcons.length],
                              title: category.name,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Trending',
                            style: context.typography.pageTitleMedium,
                          ),
                          GestureDetector(
                            onTap: () => context.goNamed('products'),
                            child: Text(
                              'VIEW ALL',
                              style: context.typography.pageTitleSmall,
                            ),
                          ),
                        ],
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: products.length > 5 ? 5 : products.length,
                        separatorBuilder: (context, index) => SizedBox(height: 16.h),
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
