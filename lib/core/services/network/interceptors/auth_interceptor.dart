import 'package:dio/dio.dart';
import 'package:furniture_ecommerce_app/core/services/auth/auth_session_notifier.dart';
import 'package:furniture_ecommerce_app/core/services/storage/secure_storage_service.dart';

/// Interceptor that automatically adds authentication tokens to requests
/// and handles 401 Unauthorized responses.
class AuthInterceptor extends Interceptor {
  final SecureStorageService _secureStorage;
  final AuthSessionNotifier? _sessionNotifier;

  AuthInterceptor(
    this._secureStorage, {
    AuthSessionNotifier? sessionNotifier,
  }) : _sessionNotifier = sessionNotifier;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _secureStorage.getAccessToken();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;
    final requestPath = err.requestOptions.path;
    final hasAuthHeader =
        err.requestOptions.headers['Authorization'] != null;
    final isAuthEndpoint = _isAuthEndpoint(requestPath);

    if (hasAuthHeader &&
        !isAuthEndpoint &&
        (statusCode == 401 || statusCode == 403)) {
      // TODO: Implement token refresh logic here
      // For now, just clear auth data and notify listeners
      await _secureStorage.clearAuthData();
      _sessionNotifier?.notifyUnauthorized();
    }

    return handler.next(err);
  }

  bool _isAuthEndpoint(String path) {
    return path.endsWith('/login') || path.endsWith('/register');
  }
}
