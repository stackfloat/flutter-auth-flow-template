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
  final List<Category> categories;
  final String selectedCategoryId;

  const ProductsLoading({
    this.categories = const [],
    this.selectedCategoryId = '',
  });

  @override
  List<Object> get props => [categories, selectedCategoryId];
}

final class ProductsLoaded extends ProductsState {
  final List<Product> products;
  final List<Category> categories;
  final List<ProductColor> colors;
  final List<ProductMaterial> materials;
  final String selectedCategoryId;

  const ProductsLoaded({
    required this.products,
    this.categories = const [],
    this.colors = const [],
    this.materials = const [],
    this.selectedCategoryId = '',
  });

  @override
  List<Object> get props =>
      [products, categories, colors, materials, selectedCategoryId];
}

final class ProductsLoadingFailure extends ProductsState {
  final String message;

  const ProductsLoadingFailure({required this.message});

  @override
  List<Object> get props => [message];
}