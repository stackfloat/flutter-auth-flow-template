import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_ecommerce_app/features/checkout/domain/entities/address.dart';
import 'package:furniture_ecommerce_app/features/checkout/domain/use_cases/get_addresses_use_case.dart';

part 'choose_address_event.dart';
part 'choose_address_state.dart';

class ChooseAddressBloc extends Bloc<ChooseAddressEvent, ChooseAddressState> {
  final GetAddressesUseCase getAddressesUseCase;

  ChooseAddressBloc(this.getAddressesUseCase) : super(ChooseAddressInitial()) {
    on<GetAddressesEvent>(_onGetAddresses);
    on<AddressSelectedEvent>(_onAddressSelected);
  }

  Future<void> _onGetAddresses(
    GetAddressesEvent event,
    Emitter<ChooseAddressState> emit,
  ) async {
    emit(ChooseAddressLoading());
    final result = await getAddressesUseCase();
    result.fold(
      (failure) => emit(
        ChooseAddressFailure(
          message: failure.message ?? 'Failed to load addresses',
        ),
      ),
      (addresses) => emit(
        ChooseAddressLoaded(
          addresses: addresses,
          selectedIndex: addresses.isNotEmpty ? 0 : null,
        ),
      ),
    );
  }

  void _onAddressSelected(
    AddressSelectedEvent event,
    Emitter<ChooseAddressState> emit,
  ) {
    final current = state;
    if (current is ChooseAddressLoaded) {
      emit(current.copyWith(selectedIndex: event.index));
    }
  }
}
