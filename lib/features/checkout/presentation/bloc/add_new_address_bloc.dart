import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'add_new_address_event.dart';
part 'add_new_address_state.dart';

class AddNewAddressBloc extends Bloc<AddNewAddressEvent, AddNewAddressState> {
  AddNewAddressBloc() : super(const AddNewAddressState()) {
    on<AddNewAddressChanged>(_onAddNewAddressChanged);
    on<AddNewAddressSaved>(_onAddNewAddressSaved);
  }

  void _onAddNewAddressChanged(
    AddNewAddressChanged event,
    Emitter<AddNewAddressState> emit,
  ) {
    emit(
      state.copyWith(
        fullName: event.fullName,
        address: event.address,
        city: event.city,
        stateRegion: event.stateRegion,
        zip: event.zip,
        country: event.country,
        phoneNumber: event.phoneNumber,
      ),
    );
  }

  void _onAddNewAddressSaved(
    AddNewAddressSaved event,
    Emitter<AddNewAddressState> emit,
  ) {
    emit(state.copyWith(isSaving: true));
    // Placeholder save flow: switch off loading immediately.
    emit(state.copyWith(isSaving: false));
  }
}
