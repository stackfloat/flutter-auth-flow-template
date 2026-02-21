part of 'product_details_bloc.dart';

sealed class ProductDetailsState extends Equatable {
  const ProductDetailsState();

  @override
  List<Object?> get props => [];
}

final class ProductDetailsInitial extends ProductDetailsState {}

final class ProductDetailsLoading extends ProductDetailsState {}

final class ProductDetailsLoaded extends ProductDetailsState {
  final ProductDetails product;

  const ProductDetailsLoaded({required this.product});

  @override
  List<Object?> get props => [product];
}

final class ProductDetailsFailure extends ProductDetailsState {
  final String message;

  const ProductDetailsFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
