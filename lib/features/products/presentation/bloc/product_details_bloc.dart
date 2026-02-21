import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_ecommerce_app/features/products/domain/entities/product_details.dart';
import 'package:furniture_ecommerce_app/features/products/domain/use_cases/get_product_details_use_case.dart';

part 'product_details_event.dart';
part 'product_details_state.dart';

class ProductDetailsBloc extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  final GetProductDetailsUseCase getProductDetailsUseCase;

  ProductDetailsBloc(this.getProductDetailsUseCase)
      : super(ProductDetailsInitial()) {
    on<GetProductDetailsEvent>(_onGetProductDetails);
  }

  Future<void> _onGetProductDetails(
    GetProductDetailsEvent event,
    Emitter<ProductDetailsState> emit,
  ) async {
    emit(ProductDetailsLoading());
    final result = await getProductDetailsUseCase(event.productId);
    result.fold(
      (failure) => emit(
        ProductDetailsFailure(
          message: failure.message ?? 'Failed to load product details',
        ),
      ),
      (product) => emit(ProductDetailsLoaded(product: product)),
    );
  }
}
