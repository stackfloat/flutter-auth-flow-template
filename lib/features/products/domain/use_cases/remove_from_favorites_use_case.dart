import 'package:furniture_ecommerce_app/core/utils/typedef.dart';
import 'package:furniture_ecommerce_app/features/products/domain/repositories/product_repository.dart';

class RemoveFromFavoritesUseCase {
  final ProductRepository repository;

  RemoveFromFavoritesUseCase(this.repository);

  ResultFuture<void> call(int productId) =>
      repository.removeFromFavorites(productId);
}
