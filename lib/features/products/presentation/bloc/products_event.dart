part of 'products_bloc.dart';

sealed class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object> get props => [];
}

final class GetProductsEvent extends ProductsEvent {
  @override
  List<Object> get props => [];
}