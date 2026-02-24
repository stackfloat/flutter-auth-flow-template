part of 'profile_favorites_bloc.dart';

enum ProfileFavoritesStatus { initial, loading, success, failure }

class ProfileFavoritesState extends Equatable {
  final ProfileFavoritesStatus status;
  final List<Product> products;
  final String? message;

  const ProfileFavoritesState({
    this.status = ProfileFavoritesStatus.initial,
    this.products = const [],
    this.message,
  });

  ProfileFavoritesState copyWith({
    ProfileFavoritesStatus? status,
    List<Product>? products,
    Object? message = _unset,
  }) {
    return ProfileFavoritesState(
      status: status ?? this.status,
      products: products ?? this.products,
      message: message == _unset ? this.message : message as String?,
    );
  }

  static const _unset = Object();

  @override
  List<Object?> get props => [status, products, message];
}
