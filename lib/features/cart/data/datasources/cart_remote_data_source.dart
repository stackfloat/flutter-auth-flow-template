import 'package:furniture_ecommerce_app/core/services/network/dio_client.dart';
import 'package:furniture_ecommerce_app/core/utils/typedef.dart';
import 'package:furniture_ecommerce_app/features/cart/data/models/cart_data_model.dart';

abstract class CartRemoteDataSource {
  ResultFuture<void> addToCart({
    required int productId,
    required int quantity,
  });

  ResultFuture<CartDataModel> getCart();

  ResultFuture<CartDataModel> updateCartItem({
    required int cartItemId,
    required int quantity,
  });

  ResultFuture<CartDataModel> removeCartItem({
    required int cartItemId,
  });
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final DioClient _dioClient;

  CartRemoteDataSourceImpl(this._dioClient);

  @override
  ResultFuture<void> addToCart({
    required int productId,
    required int quantity,
  }) {
    return _dioClient.post<void>(
      '/cart',
      data: {
        'product_id': productId,
        'quantity': quantity,
      },
      parser: (_) => null,
    );
  }

  @override
  ResultFuture<CartDataModel> getCart() {
    return _dioClient.get<CartDataModel>(
      '/cart',
      parser: _parseCartDataResponse,
    );
  }

  @override
  ResultFuture<CartDataModel> updateCartItem({
    required int cartItemId,
    required int quantity,
  }) {
    return _dioClient.patch<CartDataModel>(
      '/cart/update/$cartItemId',
      data: {
        'quantity': quantity,
      },
      parser: _parseCartDataResponse,
    );
  }

  @override
  ResultFuture<CartDataModel> removeCartItem({
    required int cartItemId,
  }) {
    return _dioClient.delete<CartDataModel>(
      '/cart/remove/$cartItemId',
      parser: _parseCartDataResponse,
    );
  }

  CartDataModel _parseCartDataResponse(dynamic data) {
    if (data is! Map<String, dynamic>) return const CartDataModel();
    return CartDataModel.fromApiJson(data);
  }
}
