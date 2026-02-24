part of 'profile_addresses_bloc.dart';

sealed class ProfileAddressesEvent extends Equatable {
  const ProfileAddressesEvent();

  @override
  List<Object?> get props => [];
}

final class ProfileAddressesLoadRequested extends ProfileAddressesEvent {
  const ProfileAddressesLoadRequested();
}

final class ProfileAddressForEditLoadRequested extends ProfileAddressesEvent {
  final int addressId;

  const ProfileAddressForEditLoadRequested({required this.addressId});

  @override
  List<Object?> get props => [addressId];
}

final class ProfileAddressEditFieldChanged extends ProfileAddressesEvent {
  final String field;
  final String value;

  const ProfileAddressEditFieldChanged({
    required this.field,
    required this.value,
  });

  @override
  List<Object?> get props => [field, value];
}

final class ProfileAddressUpdateRequested extends ProfileAddressesEvent {
  const ProfileAddressUpdateRequested();
}
