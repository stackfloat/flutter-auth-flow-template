import 'package:furniture_ecommerce_app/features/products/data/models/category_model.dart';
import 'package:furniture_ecommerce_app/features/products/data/models/color_model.dart';
import 'package:furniture_ecommerce_app/features/products/data/models/material_model.dart';
import 'package:furniture_ecommerce_app/features/products/data/models/product_model.dart';

/// Parses the API response for /products.
/// Handles both shapes:
/// - Initial: products + categories + colors + materials
/// - Pagination: products only
class ProductsResponseModel {
  final List<ProductModel> products;
  final List<CategoryModel> categories;
  final List<ColorModel> colors;
  final List<MaterialModel> materials;

  ProductsResponseModel({
    required this.products,
    this.categories = const [],
    this.colors = const [],
    this.materials = const [],
  });

  factory ProductsResponseModel.fromApiJson(Map<String, dynamic> json) {
    final products = _parseList(json, 'products', ProductModel.fromApiJson);
    final categories = _parseList(json, 'categories', CategoryModel.fromApiJson);
    final colors = _parseList(json, 'colors', ColorModel.fromApiJson);
    final materials = _parseList(json, 'materials', MaterialModel.fromApiJson);

    return ProductsResponseModel(
      products: products,
      categories: categories,
      colors: colors,
      materials: materials,
    );
  }

  static List<T> _parseList<T>(
    Map<String, dynamic> json,
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final section = json[key];
    if (section is! Map) return [];
    final data = section['data'];
    if (data is! List) return [];
    return data
        .map((e) => fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
