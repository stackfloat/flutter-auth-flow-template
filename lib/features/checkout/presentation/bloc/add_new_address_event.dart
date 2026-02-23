part of 'add_new_address_bloc.dart';

sealed class AddNewAddressEvent extends Equatable {
  const AddNewAddressEvent();

  @override
  List<Object?> get props => [];
}

final class AddNewAddressSaved extends AddNewAddressEvent {
  const AddNewAddressSaved();
}

final class AddNewAddressFieldChanged extends AddNewAddressEvent {
  final String field;
  final String value;

  const AddNewAddressFieldChanged({
    required this.field,
    required this.value,
  });

  @override
  List<Object?> get props => [field, value];
}
