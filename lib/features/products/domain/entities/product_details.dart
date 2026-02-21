import 'package:equatable/equatable.dart';
import 'package:furniture_ecommerce_app/features/products/domain/entities/category.dart';
import 'package:furniture_ecommerce_app/features/products/domain/entities/color.dart';
import 'package:furniture_ecommerce_app/features/products/domain/entities/material.dart';

class ProductDetails extends Equatable {
  final int id;
  final String name;
  final double price;
  final String description;
  final String photo;
  final bool isFavorite;
  final List<Category> categories;
  final List<ProductMaterial> materials;
  final List<ProductColor> colors;

  const ProductDetails({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.photo,
    required this.isFavorite,
    this.categories = const [],
    this.materials = const [],
    this.colors = const [],
  });

  @override
  List<Object?> get props => [
        id,
        name,
        price,
        description,
        photo,
        isFavorite,
        categories,
        materials,
        colors,
      ];
}
