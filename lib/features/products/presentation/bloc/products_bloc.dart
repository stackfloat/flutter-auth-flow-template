import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:furniture_ecommerce_app/features/products/domain/entities/product.dart';
import 'package:furniture_ecommerce_app/features/products/domain/use_cases/get_products_params.dart';
import 'package:furniture_ecommerce_app/features/products/domain/use_cases/get_products_use_case.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {

  final GetProductsUseCase getProductsUseCase;

  ProductsBloc(this.getProductsUseCase) : super(ProductsInitial()) {
    on<GetProductsEvent>(_onGetProducts);
  }

  Future<void> _onGetProducts(GetProductsEvent event, Emitter<ProductsState> emit) async {
    emit(ProductsLoading());
    final result = await getProductsUseCase(GetProductsParams(category: '', search: '', page: 1, limit: 10));
    result.fold(
      (failure) => emit(ProductsLoadingFailure(message: failure.message ?? 'An unknown error occurred')),
      (products) => emit(ProductsLoaded(products: products)),
    );
  }
}
