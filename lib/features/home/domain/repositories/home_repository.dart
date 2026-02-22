import 'package:furniture_ecommerce_app/core/utils/typedef.dart';
import 'package:furniture_ecommerce_app/features/home/domain/entities/home_dashboard_data.dart';

abstract class HomeRepository {
  ResultFuture<HomeDashboardData> getHomeDashboard();
}
