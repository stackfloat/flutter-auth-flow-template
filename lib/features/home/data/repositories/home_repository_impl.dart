import 'package:furniture_ecommerce_app/core/utils/typedef.dart';
import 'package:furniture_ecommerce_app/features/home/data/datasources/home_remote_data_source.dart';
import 'package:furniture_ecommerce_app/features/home/domain/entities/home_dashboard_data.dart';
import 'package:furniture_ecommerce_app/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource homeRemoteDataSource;

  HomeRepositoryImpl(this.homeRemoteDataSource);

  @override
  ResultFuture<HomeDashboardData> getHomeDashboard() async {
    final result = await homeRemoteDataSource.getHomeDashboard();
    return result.map((data) => data);
  }
}
