import 'package:furniture_ecommerce_app/core/utils/typedef.dart';
import 'package:furniture_ecommerce_app/features/products/domain/repositories/product_repository.dart';

class AddToFavoritesUseCase {
  final ProductRepository repository;

  AddToFavoritesUseCase(this.repository);

  ResultFuture<void> call(int productId) => repository.addToFavorites(productId);
}
