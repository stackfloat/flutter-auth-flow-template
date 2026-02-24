import 'package:furniture_ecommerce_app/core/entities/product.dart';
import 'package:furniture_ecommerce_app/core/utils/typedef.dart';
import 'package:furniture_ecommerce_app/features/products/domain/repositories/product_repository.dart';

class GetFavoritesUseCase {
  final ProductRepository repository;

  GetFavoritesUseCase(this.repository);

  ResultFuture<List<Product>> call() => repository.getFavorites();
}
