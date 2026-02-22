import 'package:furniture_ecommerce_app/core/entities/product.dart';
import 'package:furniture_ecommerce_app/features/cart/domain/entities/cart_item.dart';

class CartItemModel extends CartItem {
  const CartItemModel({
    required super.id,
    required super.product,
    required super.quantity,
  });

  factory CartItemModel.fromApiJson(Map<String, dynamic> json) {
    int parseInt(Object? value, {int fallback = 0}) {
      if (value is int) return value;
      if (value is num) return value.toInt();
      return int.tryParse(value?.toString() ?? '') ?? fallback;
    }

    double parseDouble(Object? value, {double fallback = 0}) {
      if (value is double) return value;
      if (value is num) return value.toDouble();
      return double.tryParse(value?.toString() ?? '') ?? fallback;
    }

    final product = json['product'] is Map<String, dynamic>
        ? json['product'] as Map<String, dynamic>
        : const <String, dynamic>{};

    final id = parseInt(json['id']);
    final productId = parseInt(json['product_id'], fallback: parseInt(product['id']));
    final title =
        (json['name'] ?? json['title'] ?? product['name'] ?? '').toString();
    final price = parseDouble(json['price'], fallback: parseDouble(product['price']));
    final quantity = parseInt(json['quantity'], fallback: 1);
    final photo = (json['photo'] ?? json['image'] ?? product['photo'] ?? '').toString();

    return CartItemModel(
      id: id,
      product: Product(
        id: productId,
        name: title,
        price: price,
        photo: photo,
      ),
      quantity: quantity < 1 ? 1 : quantity,
    );
  }
}
