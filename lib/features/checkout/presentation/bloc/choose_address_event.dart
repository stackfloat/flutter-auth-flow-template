part of 'choose_address_bloc.dart';

sealed class ChooseAddressEvent extends Equatable {
  const ChooseAddressEvent();

  @override
  List<Object?> get props => [];
}

final class GetAddressesEvent extends ChooseAddressEvent {
  const GetAddressesEvent();
}

final class AddressSelectedEvent extends ChooseAddressEvent {
  final int index;

  const AddressSelectedEvent(this.index);

  @override
  List<Object?> get props => [index];
}
