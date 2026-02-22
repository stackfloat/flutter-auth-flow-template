import 'package:furniture_ecommerce_app/core/utils/typedef.dart';
import 'package:furniture_ecommerce_app/features/home/domain/entities/home_dashboard_data.dart';
import 'package:furniture_ecommerce_app/features/home/domain/repositories/home_repository.dart';

class GetHomeDashboardUseCase {
  final HomeRepository homeRepository;

  GetHomeDashboardUseCase(this.homeRepository);

  ResultFuture<HomeDashboardData> call() async {
    return homeRepository.getHomeDashboard();
  }
}
