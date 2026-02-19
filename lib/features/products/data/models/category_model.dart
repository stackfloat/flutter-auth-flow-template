import 'package:furniture_ecommerce_app/features/products/domain/entities/category.dart';

class CategoryModel extends Category {
  const CategoryModel({
    required super.id,
    required super.name,
    super.icon,
  });

  factory CategoryModel.fromApiJson(Map<String, dynamic> json) {
    final idRaw = json['id'];
    if (idRaw == null) {
      throw const FormatException('Category id is required');
    }
    final id = idRaw is int
        ? idRaw
        : int.tryParse(idRaw.toString());
    if (id == null) {
      throw const FormatException('Category id must be a valid integer');
    }

    final name = json['name'] is String ? json['name'] as String : '';
    final icon = json['icon'] is String ? json['icon'] as String : '';

    return CategoryModel(
      id: id,
      name: name,
      icon: icon,
    );
  }
}
