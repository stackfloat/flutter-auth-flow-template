import 'package:equatable/equatable.dart';

class GetProductsParams extends Equatable {
  final String categoryId;
  final String search;
  final int page;
  final bool isInitialLoad;

  const GetProductsParams({
    required this.categoryId,
    required this.search,
    required this.page,
    this.isInitialLoad = false,
  });

  @override
  List<Object?> get props => [categoryId, search, page, isInitialLoad];
}