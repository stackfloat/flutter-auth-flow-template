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
  final List<Category> categories;
  final List<ProductColor> colors;
  final List<ProductMaterial> materials;

  const ProductsLoaded({
    required this.products,
    this.categories = const [],
    this.colors = const [],
    this.materials = const [],
  });

  @override
  List<Object> get props => [products, categories, colors, materials];
}

final class ProductsLoadingFailure extends ProductsState {
  final String message;

  const ProductsLoadingFailure({required this.message});

  @override
  List<Object> get props => [message];
}