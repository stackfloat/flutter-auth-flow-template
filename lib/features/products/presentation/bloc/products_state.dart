part of 'products_bloc.dart';

sealed class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object> get props => [];
}

final class ProductsInitial extends ProductsState {
  @override
  List<Object> get props => [];
}

final class ProductsLoading extends ProductsState {
  @override
  List<Object> get props => [];
}

final class ProductsLoaded extends ProductsState {
  final List<Product> products;

  const ProductsLoaded({required this.products});

  @override
  List<Object> get props => [products];
}

final class ProductsLoadingFailure extends ProductsState {
  final String message;

  const ProductsLoadingFailure({required this.message});

  @override
  List<Object> get props => [message];
}