import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_ecommerce_app/features/home/domain/entities/home_dashboard_data.dart';
import 'package:furniture_ecommerce_app/features/home/domain/use_cases/get_home_dashboard_use_case.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHomeDashboardUseCase getHomeDashboardUseCase;

  HomeBloc(this.getHomeDashboardUseCase) : super(HomeInitial()) {
    on<GetHomeDashboardEvent>(_onGetHomeDashboard);
  }

  Future<void> _onGetHomeDashboard(
    GetHomeDashboardEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    final result = await getHomeDashboardUseCase();
    result.fold(
      (failure) => emit(
        HomeLoadingFailure(
          message: failure.message ?? 'Failed to load home data',
        ),
      ),
      (data) => emit(HomeLoaded(data: data)),
    );
  }
}
