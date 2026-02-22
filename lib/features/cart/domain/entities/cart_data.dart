import 'package:equatable/equatable.dart';
import 'package:furniture_ecommerce_app/features/cart/domain/entities/cart_item.dart';

class CartData extends Equatable {
  final List<CartItem> items;
  final double subTotal;
  final double shippingFee;
  final double totalPrice;

  const CartData({
    this.items = const [],
    this.subTotal = 0,
    this.shippingFee = 0,
    this.totalPrice = 0,
  });

  @override
  List<Object?> get props => [items, subTotal, shippingFee, totalPrice];
}
