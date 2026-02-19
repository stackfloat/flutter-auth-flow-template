part of 'products_bloc.dart';

sealed class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object> get props => [];
}

final class GetProductsEvent extends ProductsEvent {
  final int page;
  final String category;
  final String search;
  final bool isInitialLoad;

  const GetProductsEvent({
    this.page = 1,
    this.category = '',
    this.search = '',
    this.isInitialLoad = false,
  });

  @override
  List<Object> get props => [page, category, search, isInitialLoad];
}