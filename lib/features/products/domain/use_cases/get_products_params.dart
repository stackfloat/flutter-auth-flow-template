import 'package:equatable/equatable.dart';

class GetProductsParams extends Equatable {
  final String category;
  final String search;
  final int page;
  final int limit;

  const GetProductsParams({
    required this.category,
    required this.search,
    required this.page,
    required this.limit,
  });

  @override
  List<Object?> get props => [category, search, page, limit];
}