part of 'products_bloc.dart';

sealed class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object?> get props => [];
}

final class GetProductsEvent extends ProductsEvent {
  final int page;
  final String? categoryId;
  final String? materialId;
  final String? colorId;
  final String? sortBy;
  final double? minPrice;
  final double? maxPrice;
  final String? search;
  final bool isInitialLoad;

  const GetProductsEvent({
    this.page = 1,
    this.categoryId,
    this.materialId,
    this.colorId,
    this.sortBy,
    this.minPrice,
    this.maxPrice,
    this.search,
    this.isInitialLoad = false,
  });

  @override
  List<Object?> get props => [
        page,
        categoryId,
        materialId,
        colorId,
        sortBy,
        minPrice,
        maxPrice,
        search,
        isInitialLoad,
      ];
}

final class ProductCategoryChanged extends ProductsEvent {
  final String categoryId;

  const ProductCategoryChanged({
    required this.categoryId,
  });

  @override
  List<Object> get props => [categoryId];
}

final class ProductFiltersUpdated extends ProductsEvent {
  final String? categoryId;
  final String? materialId;
  final String? colorId;
  final String? sortBy;
  final double? minPrice;
  final double? maxPrice;

  const ProductFiltersUpdated({
    this.categoryId,
    this.materialId,
    this.colorId,
    this.sortBy,
    this.minPrice,
    this.maxPrice,
  });

  @override
  List<Object?> get props =>
      [categoryId, materialId, colorId, sortBy, minPrice, maxPrice];
}

final class ProductFiltersApplied extends ProductsEvent {
  const ProductFiltersApplied();
}