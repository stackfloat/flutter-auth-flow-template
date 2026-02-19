import 'package:equatable/equatable.dart';

class GetProductsParams extends Equatable {
  final String category;
  final String search;
  final int page;
  final bool isInitialLoad;

  const GetProductsParams({
    required this.category,
    required this.search,
    required this.page,
    this.isInitialLoad = false,
  });

  @override
  List<Object?> get props => [category, search, page, isInitialLoad];
}