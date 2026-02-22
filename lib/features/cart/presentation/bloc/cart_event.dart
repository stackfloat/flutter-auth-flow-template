part of 'cart_bloc.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

final class GetCartEvent extends CartEvent {
  const GetCartEvent();
}

final class AddToCartEvent extends CartEvent {
  final int productId;
  final int quantity;

  const AddToCartEvent({
    required this.productId,
    this.quantity = 1,
  });

  @override
  List<Object?> get props => [productId, quantity];
}

final class UpdateCartItemEvent extends CartEvent {
  final int cartItemId;
  final int quantity;

  const UpdateCartItemEvent({
    required this.cartItemId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [cartItemId, quantity];
}

final class RemoveCartItemEvent extends CartEvent {
  final int cartItemId;

  const RemoveCartItemEvent({required this.cartItemId});

  @override
  List<Object?> get props => [cartItemId];
}
