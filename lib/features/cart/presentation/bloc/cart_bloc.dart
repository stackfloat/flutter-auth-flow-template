import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_ecommerce_app/features/cart/domain/entities/cart_data.dart';
import 'package:furniture_ecommerce_app/features/cart/domain/entities/cart_item.dart';
import 'package:furniture_ecommerce_app/features/cart/domain/use_cases/add_to_cart_use_case.dart';
import 'package:furniture_ecommerce_app/features/cart/domain/use_cases/get_cart_use_case.dart';
import 'package:furniture_ecommerce_app/features/cart/domain/use_cases/remove_cart_item_use_case.dart';
import 'package:furniture_ecommerce_app/features/cart/domain/use_cases/update_cart_item_use_case.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final AddToCartUseCase addToCartUseCase;
  final GetCartUseCase getCartUseCase;
  final UpdateCartItemUseCase updateCartItemUseCase;
  final RemoveCartItemUseCase removeCartItemUseCase;

  CartBloc(
    this.addToCartUseCase,
    this.getCartUseCase,
    this.updateCartItemUseCase,
    this.removeCartItemUseCase,
  ) : super(CartInitial()) {
    on<GetCartEvent>(_onGetCart);
    on<AddToCartEvent>(_onAddToCart);
    on<UpdateCartItemEvent>(_onUpdateCartItem);
    on<RemoveCartItemEvent>(_onRemoveCartItem);
  }

  Future<void> _onGetCart(
    GetCartEvent event,
    Emitter<CartState> emit,
  ) async {
    final previousData = _extractDataFromState();
    emit(CartLoading(previousData: previousData));
    final result = await getCartUseCase();
    result.fold(
      (failure) => emit(
        CartLoadingFailure(
          message: failure.message ?? 'Failed to load cart',
          previousData: previousData,
        ),
      ),
      (data) => emit(CartLoaded(data: data)),
    );
  }

  Future<void> _onAddToCart(
    AddToCartEvent event,
    Emitter<CartState> emit,
  ) async {
    final previousData = _extractDataFromState();
    emit(CartAddToCartInProgress(previousData: previousData));
    final result = await addToCartUseCase(
      productId: event.productId,
      quantity: event.quantity,
    );
    result.fold(
      (failure) => emit(
        CartAddToCartFailure(
          message: failure.message ?? 'Failed to add product to cart',
          previousData: previousData,
        ),
      ),
      (_) => emit(CartAddToCartSuccess(previousData: previousData)),
    );
    if (state is CartAddToCartSuccess) {
      add(const GetCartEvent());
    }
  }

  Future<void> _onUpdateCartItem(
    UpdateCartItemEvent event,
    Emitter<CartState> emit,
  ) async {
    final previousData = _extractDataFromState();
    final result = await updateCartItemUseCase(
      cartItemId: event.cartItemId,
      quantity: event.quantity,
    );
    result.fold(
      (failure) => emit(
        CartLoadingFailure(
          message: failure.message ?? 'Failed to update cart item',
          previousData: previousData,
        ),
      ),
      (data) => emit(CartLoaded(data: data)),
    );
  }

  Future<void> _onRemoveCartItem(
    RemoveCartItemEvent event,
    Emitter<CartState> emit,
  ) async {
    final previousData = _extractDataFromState();
    final result = await removeCartItemUseCase(cartItemId: event.cartItemId);
    result.fold(
      (failure) => emit(
        CartLoadingFailure(
          message: failure.message ?? 'Failed to remove cart item',
          previousData: previousData,
        ),
      ),
      (data) => emit(CartLoaded(data: data)),
    );
  }

  CartData _extractDataFromState() {
    final currentState = state;
    if (currentState is CartLoaded) return currentState.data;
    if (currentState is CartLoading) return currentState.previousData;
    if (currentState is CartLoadingFailure) return currentState.previousData;
    if (currentState is CartAddToCartInProgress) return currentState.previousData;
    if (currentState is CartAddToCartSuccess) return currentState.previousData;
    if (currentState is CartAddToCartFailure) return currentState.previousData;
    return const CartData();
  }
}
