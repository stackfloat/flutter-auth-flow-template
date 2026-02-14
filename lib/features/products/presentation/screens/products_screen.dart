import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:furniture_ecommerce_app/core/theme/app_colors.dart';
import 'package:furniture_ecommerce_app/features/products/presentation/widgets/product_filter_sheet.dart';
import 'package:furniture_ecommerce_app/features/products/presentation/widgets/product_grid_card.dart';
import 'package:furniture_ecommerce_app/features/products/presentation/widgets/products_top_bar.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 12.h),
                  ProductsTopBar(
                    onFilterTap: () => _openFilters(context),
                  ),
                  SizedBox(height: 20.h),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _products.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16.h,
                      crossAxisSpacing: 12.w,
                      childAspectRatio: 0.7,
                    ),
                    itemBuilder: (context, index) {
                      final product = _products[index];
                      return ProductGridCard(
                        title: product.title,
                        price: product.price,
                        imagePath: product.imagePath,
                        isFavorite: product.isFavorite,
                        onFavoriteTap: () {},
                        onTap: () {},
                      );
                    },
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        ),
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
  final String title;
  final double price;
  final String imagePath;
  final bool isFavorite;

  const _ProductUiModel({
    required this.title,
    required this.price,
    required this.imagePath,
    this.isFavorite = false,
  });
}

const _products = [
  _ProductUiModel(
    title: 'Teak Bench Sofa',
    price: 289.00,
    imagePath: 'assets/images/products/product_1.jpg',
    isFavorite: true,
  ),
  _ProductUiModel(
    title: 'Modern TV Unit',
    price: 349.00,
    imagePath: 'assets/images/products/product_2.jpg',
  ),
  _ProductUiModel(
    title: 'Blue Fabric Sofa',
    price: 499.00,
    imagePath: 'assets/images/products/product_3.jpeg',
  ),
  _ProductUiModel(
    title: 'Walnut Bedroom Set',
    price: 799.00,
    imagePath: 'assets/images/products/product_4.jpg',
    isFavorite: true,
  ),
  _ProductUiModel(
    title: 'Sectional Sofa',
    price: 629.00,
    imagePath: 'assets/images/products/product_5.jpeg',
  ),
  _ProductUiModel(
    title: 'Living Room Set',
    price: 549.00,
    imagePath: 'assets/images/products/product_6.png',
  ),
];
