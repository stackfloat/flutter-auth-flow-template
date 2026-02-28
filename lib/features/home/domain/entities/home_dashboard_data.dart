import 'package:equatable/equatable.dart';
import 'package:furniture_ecommerce_app/core/entities/product.dart';
import 'package:furniture_ecommerce_app/features/home/domain/entities/home_banner.dart';
import 'package:furniture_ecommerce_app/features/products/domain/entities/category.dart';

class HomeDashboardData extends Equatable {
  final List<Category> categories;
  final List<Product> products;
  final HomeBanner? banner;

  const HomeDashboardData({
    this.categories = const [],
    this.products = const [],
    this.banner,
  });

  @override
  List<Object?> get props => [categories, products, banner];
}
