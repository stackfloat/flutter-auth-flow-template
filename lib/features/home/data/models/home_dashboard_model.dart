import 'package:furniture_ecommerce_app/features/home/domain/entities/home_dashboard_data.dart';
import 'package:furniture_ecommerce_app/features/products/data/models/category_model.dart';
import 'package:furniture_ecommerce_app/features/products/data/models/product_model.dart';

class HomeDashboardModel extends HomeDashboardData {
  const HomeDashboardModel({
    super.categories,
    super.products,
  });

  factory HomeDashboardModel.fromApiJson(Map<String, dynamic> json) {
    final payload = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    List<T> parseList<T>(
      Object? raw,
      T Function(Map<String, dynamic>) parser,
    ) {
      if (raw is! List) return const [];
      return raw.whereType<Map<String, dynamic>>().map(parser).toList();
    }

    return HomeDashboardModel(
      categories: parseList(payload['categories'], CategoryModel.fromApiJson),
      products: parseList(payload['products'], ProductModel.fromApiJson),
    );
  }
}
