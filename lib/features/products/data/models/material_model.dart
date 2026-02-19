import 'package:furniture_ecommerce_app/features/products/domain/entities/material.dart';

class MaterialModel extends ProductMaterial {
  const MaterialModel({
    required super.id,
    required super.name,
  });

  factory MaterialModel.fromApiJson(Map<String, dynamic> json) {
    final idRaw = json['id'];
    if (idRaw == null) {
      throw const FormatException('Material id is required');
    }
    final id = idRaw is int
        ? idRaw
        : int.tryParse(idRaw.toString());
    if (id == null) {
      throw const FormatException('Material id must be a valid integer');
    }

    final name = json['name'] is String ? json['name'] as String : '';

    return MaterialModel(
      id: id,
      name: name,
    );
  }
}
