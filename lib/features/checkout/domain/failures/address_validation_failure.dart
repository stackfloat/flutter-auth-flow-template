import 'package:furniture_ecommerce_app/features/checkout/domain/failures/address_failure.dart';

class AddressValidationFailure extends AddressFailure {
  const AddressValidationFailure(this.fieldErrors);

  final Map<String, List<String>> fieldErrors;

  @override
  List<Object?> get props => [fieldErrors];
}
