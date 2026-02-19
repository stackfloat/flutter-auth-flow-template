import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:furniture_ecommerce_app/core/theme/app_colors.dart';
import 'package:furniture_ecommerce_app/core/theme/theme_extensions.dart';
import 'package:furniture_ecommerce_app/features/products/presentation/widgets/products_category_list.dart';
import 'package:furniture_ecommerce_app/features/products/presentation/widgets/product_filter_sheet.dart';
import 'package:furniture_ecommerce_app/features/products/presentation/widgets/product_grid_card.dart';

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
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0),
            sliver: SliverToBoxAdapter(
              child: ProductsCategoryList(
                categories: _categories,
              ),
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
                  final product = _products[index];
                  return ProductGridCard(
                    title: product.title,
                    price: product.price,
                    imagePath: product.imagePath,
                    isFavorite: product.isFavorite,
                    onFavoriteTap: () {},
                    onTap: () => context.pushNamed(
                      'product',
                      pathParameters: {'id': product.id},
                    ),
                  );
                },
                childCount: _products.length,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 16.h),
          ),
        ],
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

class _ProductUiModel {
  final String id;
  final String title;
  final double price;
  final String imagePath;
  final bool isFavorite;

  const _ProductUiModel({
    required this.id,
    required this.title,
    required this.price,
    required this.imagePath,
    this.isFavorite = false,
  });
}

const _categories = ['All', 'Sofa', 'Ceiling', 'Table Lamp', 'Floor'];

const _products = [
  _ProductUiModel(
    id: '1',
    title: 'Teak Bench SofaTeak Bench SofaTeak Bench SofaTeak Bench Sofa',
    price: 289.00,
    imagePath: 'assets/images/products/product_1.jpg',
    isFavorite: true,
  ),
  _ProductUiModel(
    id: '2',
    title: 'Modern TV UnitModern TV UnitModern TV UnitModern TV Unit',
    price: 349.00,
    imagePath: 'assets/images/products/product_2.jpg',
  ),
  _ProductUiModel(
    id: '3',
    title: 'Blue Fabric Sofa',
    price: 499.00,
    imagePath: 'assets/images/products/product_3.jpeg',
  ),
  _ProductUiModel(
    id: '4',
    title: 'Walnut Bedroom Set very stylish',
    price: 799.00,
    imagePath: 'assets/images/products/product_4.jpg',
    isFavorite: true,
  ),
  _ProductUiModel(
    id: '5',
    title: 'Sectional Sofa',
    price: 629.00,
    imagePath: 'assets/images/products/product_5.jpeg',
  ),
  _ProductUiModel(
    id: '6',
    title: 'Living Room Set',
    price: 549.00,
    imagePath: 'assets/images/products/product_6.png',
  ),
];
