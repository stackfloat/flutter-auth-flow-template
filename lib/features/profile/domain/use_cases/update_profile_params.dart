import 'package:equatable/equatable.dart';

class UpdateProfileParams extends Equatable {
  final String name;
  final String email;

  const UpdateProfileParams({
    required this.name,
    required this.email,
  });

  @override
  List<Object?> get props => [name, email];
}
