import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_ecommerce_app/core/entities/product.dart';
import 'package:furniture_ecommerce_app/features/products/data/services/favorites_notifier.dart';
import 'package:furniture_ecommerce_app/features/products/domain/use_cases/get_favorites_use_case.dart';
import 'package:furniture_ecommerce_app/features/products/domain/use_cases/remove_from_favorites_use_case.dart';

part 'profile_favorites_event.dart';
part 'profile_favorites_state.dart';

class ProfileFavoritesBloc
    extends Bloc<ProfileFavoritesEvent, ProfileFavoritesState> {
  final GetFavoritesUseCase getFavoritesUseCase;
  final RemoveFromFavoritesUseCase removeFromFavoritesUseCase;
  final FavoritesNotifier favoritesNotifier;
  StreamSubscription<({int productId, bool isFavorite})>? _favoritesSubscription;

  ProfileFavoritesBloc(
    this.getFavoritesUseCase,
    this.removeFromFavoritesUseCase,
    this.favoritesNotifier,
  ) : super(const ProfileFavoritesState()) {
    on<ProfileFavoritesRequested>(_onProfileFavoritesRequested);
    on<ProfileFavoriteRemoveRequested>(_onProfileFavoriteRemoveRequested);
    on<ProfileFavoriteChangedExternally>(_onProfileFavoriteChangedExternally);

    _favoritesSubscription = favoritesNotifier.favoriteChanges.listen((event) {
      add(ProfileFavoriteChangedExternally(
        productId: event.productId,
        isFavorite: event.isFavorite,
      ));
    });
  }

  Future<void> _onProfileFavoritesRequested(
    ProfileFavoritesRequested event,
    Emitter<ProfileFavoritesState> emit,
  ) async {
    if (event.showLoading) {
      emit(state.copyWith(
        status: ProfileFavoritesStatus.loading,
        message: null,
      ));
    }

    final result = await getFavoritesUseCase();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProfileFavoritesStatus.failure,
          message: failure.message ?? 'Failed to load favorites',
        ),
      ),
      (products) => emit(state.copyWith(
        status: ProfileFavoritesStatus.success,
        products: products,
        message: null,
      )),
    );
  }

  Future<void> _onProfileFavoriteRemoveRequested(
    ProfileFavoriteRemoveRequested event,
    Emitter<ProfileFavoritesState> emit,
  ) async {
    if (state.status != ProfileFavoritesStatus.success) return;

    final products = state.products;
    final index = products.indexWhere((p) => p.id == event.productId);
    if (index < 0) return;

    final updatedProducts = [
      ...products.sublist(0, index),
      ...products.sublist(index + 1),
    ];
    emit(state.copyWith(products: updatedProducts, message: null));

    final result = await removeFromFavoritesUseCase(event.productId);
    result.fold(
      (failure) => emit(state.copyWith(
        products: products,
        message: failure.message ?? 'Failed to remove favorite',
      )),
      (_) {},
    );
  }

  void _onProfileFavoriteChangedExternally(
    ProfileFavoriteChangedExternally event,
    Emitter<ProfileFavoritesState> emit,
  ) {
    if (state.status != ProfileFavoritesStatus.success) return;

    if (!event.isFavorite) {
      final updatedProducts =
          state.products.where((product) => product.id != event.productId).toList();
      if (updatedProducts.length != state.products.length) {
        emit(state.copyWith(products: updatedProducts));
      }
      return;
    }

    add(const ProfileFavoritesRequested(showLoading: false));
  }

  @override
  Future<void> close() {
    _favoritesSubscription?.cancel();
    return super.close();
  }
}
