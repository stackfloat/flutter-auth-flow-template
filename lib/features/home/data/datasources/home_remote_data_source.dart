import 'package:furniture_ecommerce_app/core/services/network/dio_client.dart';
import 'package:furniture_ecommerce_app/core/utils/typedef.dart';
import 'package:furniture_ecommerce_app/features/home/data/models/home_dashboard_model.dart';

abstract class HomeRemoteDataSource {
  ResultFuture<HomeDashboardModel> getHomeDashboard();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final DioClient _dioClient;

  HomeRemoteDataSourceImpl(this._dioClient);

  @override
  ResultFuture<HomeDashboardModel> getHomeDashboard() {
    return _dioClient.get<HomeDashboardModel>(
      '/home',
      parser: (data) {
        if (data is! Map<String, dynamic>) {
          throw FormatException(
              'Expected object response, got: ${data.runtimeType}');
        }
        return HomeDashboardModel.fromApiJson(data);
      },
    );
  }
}
