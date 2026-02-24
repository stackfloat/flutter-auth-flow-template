import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_ecommerce_app/core/errors/failure.dart';
import 'package:furniture_ecommerce_app/features/checkout/domain/entities/address.dart';
import 'package:furniture_ecommerce_app/features/checkout/domain/failures/address_validation_failure.dart';
import 'package:furniture_ecommerce_app/features/checkout/domain/use_cases/get_address_use_case.dart';
import 'package:furniture_ecommerce_app/features/checkout/domain/use_cases/get_addresses_use_case.dart';
import 'package:furniture_ecommerce_app/features/checkout/domain/use_cases/update_address_params.dart';
import 'package:furniture_ecommerce_app/features/checkout/domain/use_cases/update_address_use_case.dart';

part 'profile_addresses_event.dart';
part 'profile_addresses_state.dart';

class ProfileAddressesBloc
    extends Bloc<ProfileAddressesEvent, ProfileAddressesState> {
  final GetAddressesUseCase getAddressesUseCase;
  final GetAddressUseCase getAddressUseCase;
  final UpdateAddressUseCase updateAddressUseCase;

  ProfileAddressesBloc(
    this.getAddressesUseCase,
    this.getAddressUseCase,
    this.updateAddressUseCase,
  ) : super(const ProfileAddressesState()) {
    on<ProfileAddressesLoadRequested>(_onLoadAddresses);
    on<ProfileAddressForEditLoadRequested>(_onLoadAddressForEdit);
    on<ProfileAddressEditFieldChanged>(_onEditFieldChanged);
    on<ProfileAddressUpdateRequested>(_onUpdateAddress);
  }

  Future<void> _onLoadAddresses(
    ProfileAddressesLoadRequested event,
    Emitter<ProfileAddressesState> emit,
  ) async {
    emit(state.copyWith(listStatus: ProfileAddressesStatus.loading));
    final result = await getAddressesUseCase();
    result.fold(
      (failure) => emit(
        state.copyWith(
          listStatus: ProfileAddressesStatus.failure,
          listError: failure.message ?? 'Failed to load addresses',
        ),
      ),
      (addresses) => emit(
        state.copyWith(
          addresses: addresses,
          listStatus: ProfileAddressesStatus.success,
        ),
      ),
    );
  }

  Future<void> _onLoadAddressForEdit(
    ProfileAddressForEditLoadRequested event,
    Emitter<ProfileAddressesState> emit,
  ) async {
    emit(state.copyWith(
      editLoadStatus: ProfileAddressEditStatus.loading,
      editLoadError: null,
    ));
    final result = await getAddressUseCase(event.addressId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          editLoadStatus: ProfileAddressEditStatus.failure,
          editLoadError: failure.message ?? 'Failed to load address',
        ),
      ),
      (address) => emit(
        state.copyWith(
          addressForEdit: address,
          editLoadStatus: ProfileAddressEditStatus.success,
          fullName: address.name,
          phoneNumber: address.phone,
          address: address.address,
          city: address.city,
          stateRegion: address.state,
          zip: address.zip,
          country: address.country,
          formSubmitted: false,
          errors: ProfileAddressEditErrors.empty,
          serverError: null,
        ),
      ),
    );
  }

  void _onEditFieldChanged(
    ProfileAddressEditFieldChanged event,
    Emitter<ProfileAddressesState> emit,
  ) {
    final value = event.value.trim();
    ProfileAddressesState nextState = state;
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

  Future<void> _onUpdateAddress(
    ProfileAddressUpdateRequested event,
    Emitter<ProfileAddressesState> emit,
  ) async {
    final address = state.addressForEdit;
    if (address == null || state.updateStatus == ProfileAddressEditStatus.loading) {
      return;
    }

    final errors = _validateForm(state);
    emit(
      state.copyWith(
        formSubmitted: true,
        errors: errors,
        serverError: null,
      ),
    );

    if (errors.hasErrors) return;

    emit(state.copyWith(updateStatus: ProfileAddressEditStatus.loading));

    final result = await updateAddressUseCase(
      UpdateAddressParams(
        id: address.id,
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
              updateStatus: ProfileAddressEditStatus.failure,
              errors: _mapFailureToErrors(failure.fieldErrors),
              serverError: null,
            ),
          );
          return;
        }
        emit(
          state.copyWith(
            updateStatus: ProfileAddressEditStatus.failure,
            serverError: _mapFailureToMessage(failure),
          ),
        );
      },
      (_) => emit(state.copyWith(updateStatus: ProfileAddressEditStatus.success)),
    );
  }

  ProfileAddressEditErrors _validateForm(ProfileAddressesState s) {
    return ProfileAddressEditErrors(
      fullName: s.fullName.isEmpty ? 'Full name is required' : null,
      phoneNumber: s.phoneNumber.isEmpty ? 'Phone number is required' : null,
      address: s.address.isEmpty ? 'Address is required' : null,
      city: s.city.isEmpty ? 'City is required' : null,
      stateRegion: s.stateRegion.isEmpty ? 'State is required' : null,
      zip: s.zip.isEmpty ? 'ZIP is required' : null,
      country: s.country.isEmpty ? 'Country is required' : null,
    );
  }

  ProfileAddressEditErrors _mapFailureToErrors(Map<String, List<String>> fieldErrors) {
    String? first(String key) {
      final errors = fieldErrors[key];
      if (errors == null || errors.isEmpty) return null;
      return errors.first;
    }
    return ProfileAddressEditErrors(
      fullName: first('name'),
      phoneNumber: first('phone'),
      address: first('address'),
      city: first('city'),
      stateRegion: first('state'),
      zip: first('zip'),
      country: first('country'),
    );
  }

  String _mapFailureToMessage(Failure failure) {
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
