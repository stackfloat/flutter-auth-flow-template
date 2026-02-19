import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:furniture_ecommerce_app/features/products/domain/entities/category.dart';
import 'package:furniture_ecommerce_app/features/products/domain/entities/color.dart';
import 'package:furniture_ecommerce_app/features/products/domain/entities/material.dart';
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

  Future<void> _onGetProducts(
      GetProductsEvent event, Emitter<ProductsState> emit) async {
    final previousState = state is ProductsLoaded ? state as ProductsLoaded : null;
    emit(ProductsLoading());
    final result = await getProductsUseCase(
      GetProductsParams(
        category: event.category,
        search: event.search,
        page: event.page,
        isInitialLoad: event.isInitialLoad,
      ),
    );
    result.fold(
      (failure) => emit(ProductsLoadingFailure(
          message: failure.message ?? 'An unknown error occurred')),
      (data) => emit(ProductsLoaded(
        products: data.products,
        categories: event.isInitialLoad || data.categories.isNotEmpty
            ? data.categories
            : (previousState?.categories ?? const []),
        colors: event.isInitialLoad || data.colors.isNotEmpty
            ? data.colors
            : (previousState?.colors ?? const []),
        materials: event.isInitialLoad || data.materials.isNotEmpty
            ? data.materials
            : (previousState?.materials ?? const []),
      )),
    );
  }
}
