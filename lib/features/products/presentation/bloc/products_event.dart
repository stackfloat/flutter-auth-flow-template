part of 'products_bloc.dart';

sealed class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object> get props => [];
}

final class GetProductsEvent extends ProductsEvent {
  final int page;
  final String categoryId;
  final String search;
  final bool isInitialLoad;

  const GetProductsEvent({
    this.page = 1,
    this.categoryId = '',
    this.search = '',
    this.isInitialLoad = false,
  });

  @override
  List<Object> get props => [page, categoryId, search, isInitialLoad];
}

final class ProductCategoryChanged extends ProductsEvent {
  final String categoryId;

  const ProductCategoryChanged({
    required this.categoryId,
  });

  @override
  List<Object> get props => [categoryId];
}