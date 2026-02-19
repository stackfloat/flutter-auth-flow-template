import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int id;
  final String title;
  final double price;
  final String imagePath;
  final bool isFavorite;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.imagePath,
    this.isFavorite = false,
  });

  @override
  List<Object?> get props => [id, title, price, imagePath, isFavorite];
}
