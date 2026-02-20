import 'package:furniture_ecommerce_app/features/products/domain/entities/category_list_item.dart';

class CategoryListItemModel extends CategoryListItem {
  const CategoryListItemModel({
    required super.id,
    required super.name,
    required super.productsCount,
  });

  factory CategoryListItemModel.fromApiJson(Map<String, dynamic> json) {
    int parseInt(Object? value, {int fallback = 0}) {
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value) ?? fallback;
      return fallback;
    }

    final id = parseInt(json['id']);
    if (id == 0) {
      throw const FormatException('Category id is required');
    }

    final name = json['name'] is String ? json['name'] as String : '';
    final productsCount = parseInt(json['products_count']);

    return CategoryListItemModel(
      id: id,
      name: name,
      productsCount: productsCount,
    );
  }
}
