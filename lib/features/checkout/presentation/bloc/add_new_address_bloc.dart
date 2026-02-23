import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_ecommerce_app/core/errors/failure.dart';
import 'package:furniture_ecommerce_app/features/checkout/domain/failures/address_validation_failure.dart';
import 'package:furniture_ecommerce_app/features/checkout/domain/use_cases/create_address_params.dart';
import 'package:furniture_ecommerce_app/features/checkout/domain/use_cases/create_address_use_case.dart';
import 'package:furniture_ecommerce_app/features/checkout/presentation/bloc/add_new_address_errors.dart';

part 'add_new_address_event.dart';
part 'add_new_address_state.dart';

class AddNewAddressBloc extends Bloc<AddNewAddressEvent, AddNewAddressState> {
  final CreateAddressUseCase createAddressUseCase;

  AddNewAddressBloc(this.createAddressUseCase)
      : super(const AddNewAddressState()) {
    on<AddNewAddressFieldChanged>(_onAddNewAddressFieldChanged);
    on<AddNewAddressSaved>(_onAddNewAddressSaved);
  }

  void _onAddNewAddressFieldChanged(
    AddNewAddressFieldChanged event,
    Emitter<AddNewAddressState> emit,
  ) {
    final value = event.value.trim();

    AddNewAddressState nextState = state;
    if (event.field == 'fullName') {
      nextState = state.copyWith(fullName: value);
    } else if (event.field == 'phoneNumber') {
      nextState = state.copyWith(phoneNumber: value);
    } else if (event.field == 'address') {
      nextState = state.copyWith(address: value);
    } else if (event.field == 'city') {
      nextState = state.copyWith(city: value);
    } else if (event.field == 'stateRegion') {
      nextState = state.copyWith(stateRegion: value);
    } else if (event.field == 'zip') {
      nextState = state.copyWith(zip: value);
    } else if (event.field == 'country') {
      nextState = state.copyWith(country: value);
    }

    emit(
      nextState.copyWith(
        serverError: null,
        errors: state.formSubmitted
            ? _validateForm(nextState)
            : nextState.errors,
      ),
    );
  }

  Future<void> _onAddNewAddressSaved(
    AddNewAddressSaved event,
    Emitter<AddNewAddressState> emit,
  ) async {
    if (state.status == AddNewAddressStatus.loading) return;

    final errors = _validateForm(state);
    emit(
      state.copyWith(
        formSubmitted: true,
        errors: errors,
        serverError: null,
      ),
    );

    if (errors.hasErrors) return;

    emit(state.copyWith(status: AddNewAddressStatus.loading));

    final result = await createAddressUseCase(
      CreateAddressParams(
        name: state.fullName,
        phone: state.phoneNumber,
        address: state.address,
        city: state.city,
        state: state.stateRegion,
        zip: state.zip,
        country: state.country,
      ),
    );

    result.fold(
      (failure) {
        if (failure is AddressValidationFailure) {
          emit(
            state.copyWith(
              status: AddNewAddressStatus.failure,
              errors: _mapFailureToUiErrors(failure.fieldErrors),
              serverError: null,
            ),
          );
          return;
        }

        emit(
          state.copyWith(
            status: AddNewAddressStatus.failure,
            serverError: _mapFailureToGlobalMessage(failure),
          ),
        );
      },
      (_) => emit(state.copyWith(status: AddNewAddressStatus.success)),
    );
  }

  AddNewAddressErrors _validateForm(AddNewAddressState state) {
    return AddNewAddressErrors(
      fullName: state.fullName.isEmpty ? 'Full name is required' : null,
      phoneNumber: state.phoneNumber.isEmpty ? 'Phone number is required' : null,
      address: state.address.isEmpty ? 'Address is required' : null,
      city: state.city.isEmpty ? 'City is required' : null,
      stateRegion: state.stateRegion.isEmpty ? 'State is required' : null,
      zip: state.zip.isEmpty ? 'ZIP is required' : null,
      country: state.country.isEmpty ? 'Country is required' : null,
    );
  }

  AddNewAddressErrors _mapFailureToUiErrors(Map<String, List<String>> fieldErrors) {
    String? firstError(String key) {
      final errors = fieldErrors[key];
      if (errors == null || errors.isEmpty) return null;
      return errors.first;
    }

    return AddNewAddressErrors(
      fullName: firstError('name'),
      phoneNumber: firstError('phone'),
      address: firstError('address'),
      city: firstError('city'),
      stateRegion: firstError('state'),
      zip: firstError('zip'),
      country: firstError('country'),
    );
  }

  String _mapFailureToGlobalMessage(Failure failure) {
    if (failure is NetworkFailure) {
      return failure.message ?? 'Network error. Unexpected error occurred.';
    }

    if (failure is ServerFailure) {
      return failure.message ?? 'Something went wrong. Please try again later.';
    }

    if (failure is ApiFailure) {
      if (failure.statusCode == 0) {
        return failure.message ?? 'Network error. Unexpected error occurred.';
      }
      return failure.message ?? 'Something went wrong. Please try again later.';
    }

    return failure.message ?? 'Unexpected error occurred.';
  }
}
