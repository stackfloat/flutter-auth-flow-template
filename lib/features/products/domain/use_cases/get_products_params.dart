import 'package:equatable/equatable.dart';

class GetProductsParams extends Equatable {
  final String category;
  final String search;
  final int page;

  const GetProductsParams({
    required this.category,
    required this.search,
    required this.page,
  });

  @override
  List<Object?> get props => [category, search, page];
}