part of 'choose_address_bloc.dart';

sealed class ChooseAddressState extends Equatable {
  const ChooseAddressState();

  @override
  List<Object?> get props => [];
}

final class ChooseAddressInitial extends ChooseAddressState {}

final class ChooseAddressLoading extends ChooseAddressState {}

final class ChooseAddressLoaded extends ChooseAddressState {
  final List<Address> addresses;
  final int? selectedIndex;

  const ChooseAddressLoaded({
    required this.addresses,
    this.selectedIndex,
  });

  Address? get selectedAddress =>
      selectedIndex != null &&
      selectedIndex! >= 0 &&
      selectedIndex! < addresses.length
          ? addresses[selectedIndex!]
          : null;

  ChooseAddressLoaded copyWith({
    List<Address>? addresses,
    int? selectedIndex,
  }) {
    return ChooseAddressLoaded(
      addresses: addresses ?? this.addresses,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }

  @override
  List<Object?> get props => [addresses, selectedIndex];
}

final class ChooseAddressFailure extends ChooseAddressState {
  final String message;

  const ChooseAddressFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
