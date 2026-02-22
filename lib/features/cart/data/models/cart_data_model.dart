import 'package:furniture_ecommerce_app/features/cart/data/models/cart_item_model.dart';
import 'package:furniture_ecommerce_app/features/cart/domain/entities/cart_data.dart';

class CartDataModel extends CartData {
  const CartDataModel({
    super.items,
    super.subTotal,
    super.shippingFee,
    super.totalPrice,
  });

  factory CartDataModel.fromApiJson(Map<String, dynamic> json) {
    final payload = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    double parseDouble(Object? value, {double fallback = 0}) {
      if (value is double) return value;
      if (value is num) return value.toDouble();
      return double.tryParse(value?.toString() ?? '') ?? fallback;
    }

    final itemsRaw = payload['cart'] ?? payload['items'] ?? payload['cart_items'];
    final items = itemsRaw is List
        ? itemsRaw
            .whereType<Map<String, dynamic>>()
            .map(CartItemModel.fromApiJson)
            .toList()
        : const <CartItemModel>[];

    return CartDataModel(
      items: items,
      subTotal: parseDouble(payload['sub_total']),
      shippingFee: parseDouble(payload['shipping_fee']),
      totalPrice: parseDouble(payload['total_price']),
    );
  }
}
