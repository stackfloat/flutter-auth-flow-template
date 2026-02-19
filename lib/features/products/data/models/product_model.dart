import 'package:furniture_ecommerce_app/features/products/domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.title,
    required super.price,
    required super.imagePath,
    required super.isFavorite,
  });

  factory ProductModel.fromApiJson(Map<String, dynamic> json) {
    final idRaw = json['id'];
    if (idRaw == null) {
      throw const FormatException('Product id is required');
    }
    final id = idRaw is int
        ? idRaw
        : int.tryParse(idRaw.toString());
    if (id == null) {
      throw const FormatException('Product id must be a valid integer');
    }

    final title = json['title'] is String ? json['title'] as String : '';

    final priceRaw = json['price'];
    final price = priceRaw is int
        ? priceRaw.toDouble()
        : priceRaw is num
            ? priceRaw.toDouble()
            : (double.tryParse(priceRaw?.toString() ?? '') ?? 0.0);

    final imagePath =
        json['imagePath'] is String ? json['imagePath'] as String : '';

    return ProductModel(
      id: id,
      title: title,
      price: price.isNaN ? 0.0 : price,
      imagePath: imagePath,
      isFavorite: json['isFavorite'] == true,
    );
  }
}