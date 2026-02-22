part of 'cart_bloc.dart';

sealed class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

final class CartInitial extends CartState {}

final class CartLoading extends CartState {
  final CartData previousData;

  const CartLoading({this.previousData = const CartData()});

  @override
  List<Object?> get props => [previousData];
}

final class CartLoaded extends CartState {
  final CartData data;

  const CartLoaded({required this.data});

  @override
  List<Object?> get props => [data];
}

final class CartLoadingFailure extends CartState {
  final String message;
  final CartData previousData;

  const CartLoadingFailure({
    required this.message,
    this.previousData = const CartData(),
  });

  @override
  List<Object?> get props => [message, previousData];
}

final class CartAddToCartInProgress extends CartState {
  final CartData previousData;

  const CartAddToCartInProgress({this.previousData = const CartData()});

  @override
  List<Object?> get props => [previousData];
}

final class CartAddToCartSuccess extends CartState {
  final CartData previousData;

  const CartAddToCartSuccess({this.previousData = const CartData()});

  @override
  List<Object?> get props => [previousData];
}

final class CartAddToCartFailure extends CartState {
  final String message;
  final CartData previousData;

  const CartAddToCartFailure({
    required this.message,
    this.previousData = const CartData(),
  });

  @override
  List<Object?> get props => [message, previousData];
}
