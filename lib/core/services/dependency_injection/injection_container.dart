import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:furniture_ecommerce_app/core/services/auth/auth_session_notifier.dart';
import 'package:furniture_ecommerce_app/core/services/logging/app_logger.dart';
import 'package:furniture_ecommerce_app/core/services/network/dio_client.dart';
import 'package:furniture_ecommerce_app/core/services/storage/secure_storage_service.dart';
import 'package:furniture_ecommerce_app/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:furniture_ecommerce_app/features/authentication/data/repositories/auth_respository_impl.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/repositories/auth_repository.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/usecases/clear_session_usecase.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/usecases/get_current_user_usecase.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/usecases/logout_usecase.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/usecases/signin_usecase.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/usecases/signup_usecase.dart';
import 'package:furniture_ecommerce_app/features/authentication/presentation/bloc/signin/signin_bloc.dart';
import 'package:furniture_ecommerce_app/features/authentication/presentation/bloc/signup/signup_bloc.dart';
import 'package:furniture_ecommerce_app/features/products/data/datasources/product_remote_data_source.dart';
import 'package:furniture_ecommerce_app/features/products/data/repositories/product_repository_impl.dart';
import 'package:furniture_ecommerce_app/features/products/domain/repositories/product_repository.dart';
import 'package:furniture_ecommerce_app/features/products/domain/use_cases/get_products_use_case.dart';
import 'package:furniture_ecommerce_app/features/products/presentation/bloc/products_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service Locator for Dependency Injection
final sl = GetIt.instance;

/// Initialize all dependencies
/// 
/// Call this once at app startup in main.dart:
/// ```dart
/// await initDependencies();
/// ```
Future<void> initDependencies() async {
  // ---------------------------------------------------------------------------
  // External Dependencies (Third-party packages)
  // ---------------------------------------------------------------------------
  
  // SharedPreferences - Must be initialized asynchronously
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // FlutterSecureStorage
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(
      aOptions: AndroidOptions(
        
      ),
    ),
  );

  // Logger
  sl.registerLazySingleton<Logger>(() => Logger());

  // Firebase Crashlytics
  sl.registerLazySingleton<FirebaseCrashlytics>(
    () => FirebaseCrashlytics.instance,
  );

  // ---------------------------------------------------------------------------
  // Core Services
  // ---------------------------------------------------------------------------

  // App Logger
  sl.registerLazySingleton<AppLogger>(
    () => AppLogger(
      logger: sl<Logger>(),
      crashlytics: sl<FirebaseCrashlytics>(),
    ),
  );

  // Auth Session Notifier
  sl.registerLazySingleton<AuthSessionNotifier>(
    () => AuthSessionNotifier(),
  );

  // Secure Storage Service
  sl.registerLazySingleton<SecureStorageService>(
    () => SecureStorageServiceImpl(
      sl<FlutterSecureStorage>(),
      sl<SharedPreferences>(),
    ),
  );

  // Initialize SecureStorageService
  await sl<SecureStorageService>().init();

  // Network Client
  sl.registerLazySingleton<DioClient>(
    () => DioClient(
      sl<SecureStorageService>(),
      sessionNotifier: sl<AuthSessionNotifier>(),
    ),
  );

  // ---------------------------------------------------------------------------
  // Features - Authentication
  // ---------------------------------------------------------------------------

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<DioClient>()),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      sl<AuthRemoteDataSource>(),
      sl<SecureStorageService>(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton<SigninUseCase>(
    () => SigninUseCase(sl<AuthRepository>()),
  );
  
  sl.registerLazySingleton<SignupUseCase>(
    () => SignupUseCase(sl<AuthRepository>()),
  );
  
  sl.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(sl<AuthRepository>()),
  );

  sl.registerLazySingleton<GetCurrentUserUseCase>(
    () => GetCurrentUserUseCase(sl<AuthRepository>()),
  );

  sl.registerLazySingleton<ClearSessionUseCase>(
    () => ClearSessionUseCase(sl<AuthRepository>()),
  );

  // Blocs
  sl.registerFactory<SigninBloc>(
    () => SigninBloc(sl<SigninUseCase>()),
  );

  sl.registerFactory<SignupBloc>(
    () => SignupBloc(sl<SignupUseCase>()),
  );

  // ---------------------------------------------------------------------------
  // Features - Products
  // ---------------------------------------------------------------------------

  // Data Sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(sl<DioClient>()),
  );

  // Repository
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      sl<ProductRemoteDataSource>(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton<GetProductsUseCase>(
    () => GetProductsUseCase(sl<ProductRepository>()),
  );

  // Blocs
  sl.registerFactory<ProductsBloc>(
    () => ProductsBloc(sl<GetProductsUseCase>()),
  );

  // ---------------------------------------------------------------------------
  // Features - Other Features (Add as needed)
  // ---------------------------------------------------------------------------

  // TODO: Add more features here as they're implemented
}

/// Clean up dependencies (useful for testing)
Future<void> resetDependencies() async {
  await sl.reset();
}
