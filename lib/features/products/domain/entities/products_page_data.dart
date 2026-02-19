import 'package:equatable/equatable.dart';
import 'package:furniture_ecommerce_app/features/products/domain/entities/category.dart';
import 'package:furniture_ecommerce_app/features/products/domain/entities/color.dart';
import 'package:furniture_ecommerce_app/features/products/domain/entities/material.dart';
import 'package:furniture_ecommerce_app/features/products/domain/entities/product.dart';

/// Domain entity holding products with filter options (categories, colors, materials).
/// Used for initial load (all data) and pagination (products only).
class ProductsPageData extends Equatable {
  final List<Product> products;
  final List<Category> categories;
  final List<ProductColor> colors;
  final List<ProductMaterial> materials;

  const ProductsPageData({
    required this.products,
    this.categories = const [],
    this.colors = const [],
    this.materials = const [],
  });

  @override
  List<Object?> get props => [products, categories, colors, materials];
}
