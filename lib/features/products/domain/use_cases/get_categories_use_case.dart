import 'package:furniture_ecommerce_app/core/utils/typedef.dart';
import 'package:furniture_ecommerce_app/features/products/domain/entities/category_list_item.dart';
import 'package:furniture_ecommerce_app/features/products/domain/repositories/product_repository.dart';

class GetCategoriesUseCase {
  final ProductRepository productRepository;

  GetCategoriesUseCase(this.productRepository);

  ResultFuture<List<CategoryListItem>> call() async {
    return productRepository.getCategories();
  }
}
