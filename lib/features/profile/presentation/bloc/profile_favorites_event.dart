part of 'profile_favorites_bloc.dart';

sealed class ProfileFavoritesEvent extends Equatable {
  const ProfileFavoritesEvent();

  @override
  List<Object?> get props => [];
}

final class ProfileFavoritesRequested extends ProfileFavoritesEvent {
  final bool showLoading;

  const ProfileFavoritesRequested({this.showLoading = true});

  @override
  List<Object?> get props => [showLoading];
}

final class ProfileFavoriteRemoveRequested extends ProfileFavoritesEvent {
  final int productId;

  const ProfileFavoriteRemoveRequested({required this.productId});

  @override
  List<Object?> get props => [productId];
}

final class ProfileFavoriteChangedExternally extends ProfileFavoritesEvent {
  final int productId;
  final bool isFavorite;

  const ProfileFavoriteChangedExternally({
    required this.productId,
    required this.isFavorite,
  });

  @override
  List<Object?> get props => [productId, isFavorite];
}
