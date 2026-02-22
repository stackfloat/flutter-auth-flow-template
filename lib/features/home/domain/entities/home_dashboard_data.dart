import 'package:equatable/equatable.dart';
import 'package:furniture_ecommerce_app/features/products/domain/entities/category.dart';
import 'package:furniture_ecommerce_app/features/products/domain/entities/product.dart';

class HomeDashboardData extends Equatable {
  final List<Category> categories;
  final List<Product> products;

  const HomeDashboardData({
    this.categories = const [],
    this.products = const [],
  });

  @override
  List<Object?> get props => [categories, products];
}
