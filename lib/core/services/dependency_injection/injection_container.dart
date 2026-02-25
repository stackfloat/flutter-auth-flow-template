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
import 'package:furniture_ecommerce_app/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:furniture_ecommerce_app/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:furniture_ecommerce_app/features/cart/domain/repositories/cart_repository.dart';
import 'package:furniture_ecommerce_app/features/cart/domain/use_cases/add_to_cart_use_case.dart';
import 'package:furniture_ecommerce_app/features/cart/domain/use_cases/get_cart_use_case.dart';
import 'package:furniture_ecommerce_app/features/cart/domain/use_cases/remove_cart_item_use_case.dart';
import 'package:furniture_ecommerce_app/features/cart/domain/use_cases/update_cart_item_use_case.dart';
import 'package:furniture_ecommerce_app/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:furniture_ecommerce_app/features/checkout/data/datasources/address_remote_data_source.dart';
import 'package:furniture_ecommerce_app/features/checkout/data/repositories/address_repository_impl.dart';
import 'package:furniture_ecommerce_app/features/checkout/domain/repositories/address_repository.dart';
import 'package:furniture_ecommerce_app/features/checkout/domain/use_cases/create_address_use_case.dart';
import 'package:furniture_ecommerce_app/features/checkout/domain/use_cases/get_address_use_case.dart';
import 'package:furniture_ecommerce_app/features/checkout/domain/use_cases/get_addresses_use_case.dart';
import 'package:furniture_ecommerce_app/features/checkout/domain/use_cases/update_address_use_case.dart';
import 'package:furniture_ecommerce_app/features/checkout/presentation/bloc/add_new_address_bloc.dart';
import 'package:furniture_ecommerce_app/features/checkout/presentation/bloc/choose_address_bloc.dart';
import 'package:furniture_ecommerce_app/features/home/data/datasources/home_remote_data_source.dart';
import 'package:furniture_ecommerce_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:furniture_ecommerce_app/features/home/domain/repositories/home_repository.dart';
import 'package:furniture_ecommerce_app/features/home/domain/use_cases/get_home_dashboard_use_case.dart';
import 'package:furniture_ecommerce_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:furniture_ecommerce_app/features/products/data/datasources/product_remote_data_source.dart';
import 'package:furniture_ecommerce_app/features/products/data/repositories/product_repository_impl.dart';
import 'package:furniture_ecommerce_app/features/products/data/services/favorites_notifier.dart';
import 'package:furniture_ecommerce_app/features/products/domain/repositories/product_repository.dart';
import 'package:furniture_ecommerce_app/features/products/domain/use_cases/add_to_favorites_use_case.dart';
import 'package:furniture_ecommerce_app/features/products/domain/use_cases/get_categories_use_case.dart';
import 'package:furniture_ecommerce_app/features/products/domain/use_cases/get_favorites_use_case.dart';
import 'package:furniture_ecommerce_app/features/products/domain/use_cases/get_product_details_use_case.dart';
import 'package:furniture_ecommerce_app/features/products/domain/use_cases/get_products_use_case.dart';
import 'package:furniture_ecommerce_app/features/products/domain/use_cases/remove_from_favorites_use_case.dart';
import 'package:furniture_ecommerce_app/features/products/presentation/bloc/categories_bloc.dart';
import 'package:furniture_ecommerce_app/features/products/presentation/bloc/product_details_bloc.dart';
import 'package:furniture_ecommerce_app/features/products/presentation/bloc/products_bloc.dart';
import 'package:furniture_ecommerce_app/features/profile/presentation/bloc/profile_addresses_bloc.dart';
import 'package:furniture_ecommerce_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:furniture_ecommerce_app/features/profile/presentation/bloc/profile_edit_profile_bloc.dart';
import 'package:furniture_ecommerce_app/features/profile/presentation/bloc/profile_favorites_bloc.dart';
import 'package:furniture_ecommerce_app/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:furniture_ecommerce_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:furniture_ecommerce_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:furniture_ecommerce_app/features/profile/domain/use_cases/change_password_use_case.dart';
import 'package:furniture_ecommerce_app/features/profile/domain/use_cases/get_profile_use_case.dart';
import 'package:furniture_ecommerce_app/features/profile/domain/use_cases/update_profile_use_case.dart';
import 'package:furniture_ecommerce_app/features/profile/presentation/bloc/profile_change_password_bloc.dart';
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
  // Features - Cart
  // ---------------------------------------------------------------------------

  // Data Sources
  sl.registerLazySingleton<CartRemoteDataSource>(
    () => CartRemoteDataSourceImpl(sl<DioClient>()),
  );

  // Repository
  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(sl<CartRemoteDataSource>()),
  );

  // Use Cases
  sl.registerLazySingleton<AddToCartUseCase>(
    () => AddToCartUseCase(sl<CartRepository>()),
  );
  sl.registerLazySingleton<GetCartUseCase>(
    () => GetCartUseCase(sl<CartRepository>()),
  );
  sl.registerLazySingleton<UpdateCartItemUseCase>(
    () => UpdateCartItemUseCase(sl<CartRepository>()),
  );
  sl.registerLazySingleton<RemoveCartItemUseCase>(
    () => RemoveCartItemUseCase(sl<CartRepository>()),
  );

  // Blocs
  sl.registerFactory<CartBloc>(
    () => CartBloc(
      sl<AddToCartUseCase>(),
      sl<GetCartUseCase>(),
      sl<UpdateCartItemUseCase>(),
      sl<RemoveCartItemUseCase>(),
    ),
  );

  // ---------------------------------------------------------------------------
  // Features - Checkout
  // ---------------------------------------------------------------------------

  // Data Sources
  sl.registerLazySingleton<AddressRemoteDataSource>(
    () => AddressRemoteDataSourceImpl(sl<DioClient>()),
  );

  // Repository
  sl.registerLazySingleton<AddressRepository>(
    () => AddressRepositoryImpl(sl<AddressRemoteDataSource>()),
  );

  // Use Cases
  sl.registerLazySingleton<CreateAddressUseCase>(
    () => CreateAddressUseCase(sl<AddressRepository>()),
  );
  sl.registerLazySingleton<GetAddressesUseCase>(
    () => GetAddressesUseCase(sl<AddressRepository>()),
  );
  sl.registerLazySingleton<GetAddressUseCase>(
    () => GetAddressUseCase(sl<AddressRepository>()),
  );
  sl.registerLazySingleton<UpdateAddressUseCase>(
    () => UpdateAddressUseCase(sl<AddressRepository>()),
  );

  // ---------------------------------------------------------------------------
  // Features - Profile
  // ---------------------------------------------------------------------------

  // Data Sources
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(sl<DioClient>()),
  );

  // Repository
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl<ProfileRemoteDataSource>()),
  );

  // Use Cases
  sl.registerLazySingleton<GetProfileUseCase>(
    () => GetProfileUseCase(sl<ProfileRepository>()),
  );
  sl.registerLazySingleton<UpdateProfileUseCase>(
    () => UpdateProfileUseCase(sl<ProfileRepository>()),
  );
  sl.registerLazySingleton<ChangePasswordUseCase>(
    () => ChangePasswordUseCase(sl<ProfileRepository>()),
  );

  // Blocs
  sl.registerFactory<ProfileBloc>(
    () => ProfileBloc(sl<GetProfileUseCase>()),
  );
  sl.registerFactory<ProfileEditProfileBloc>(
    () => ProfileEditProfileBloc(
      sl<GetProfileUseCase>(),
      sl<UpdateProfileUseCase>(),
    ),
  );
  sl.registerFactory<ProfileChangePasswordBloc>(
    () => ProfileChangePasswordBloc(sl<ChangePasswordUseCase>()),
  );
  sl.registerFactory<ProfileAddressesBloc>(
    () => ProfileAddressesBloc(
      sl<GetAddressesUseCase>(),
      sl<GetAddressUseCase>(),
      sl<UpdateAddressUseCase>(),
    ),
  );
  sl.registerFactory<ChooseAddressBloc>(
    () => ChooseAddressBloc(sl<GetAddressesUseCase>()),
  );
  sl.registerFactory<AddNewAddressBloc>(
    () => AddNewAddressBloc(sl<CreateAddressUseCase>()),
  );

  // ---------------------------------------------------------------------------
  // Features - Home
  // ---------------------------------------------------------------------------

  // Data Sources
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(sl<DioClient>()),
  );

  // Repository
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(sl<HomeRemoteDataSource>()),
  );

  // Use Cases
  sl.registerLazySingleton<GetHomeDashboardUseCase>(
    () => GetHomeDashboardUseCase(sl<HomeRepository>()),
  );

  // Blocs
  sl.registerFactory<HomeBloc>(
    () => HomeBloc(sl<GetHomeDashboardUseCase>()),
  );

  // ---------------------------------------------------------------------------
  // Features - Products
  // ---------------------------------------------------------------------------

  // Data Sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(sl<DioClient>()),
  );

  // Services
  sl.registerLazySingleton<FavoritesNotifier>(() => FavoritesNotifier());

  // Repository
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      sl<ProductRemoteDataSource>(),
      sl<FavoritesNotifier>(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton<GetProductsUseCase>(
    () => GetProductsUseCase(sl<ProductRepository>()),
  );
  sl.registerLazySingleton<GetCategoriesUseCase>(
    () => GetCategoriesUseCase(sl<ProductRepository>()),
  );
  sl.registerLazySingleton<GetProductDetailsUseCase>(
    () => GetProductDetailsUseCase(sl<ProductRepository>()),
  );
  sl.registerLazySingleton<GetFavoritesUseCase>(
    () => GetFavoritesUseCase(sl<ProductRepository>()),
  );
  sl.registerLazySingleton<AddToFavoritesUseCase>(
    () => AddToFavoritesUseCase(sl<ProductRepository>()),
  );
  sl.registerLazySingleton<RemoveFromFavoritesUseCase>(
    () => RemoveFromFavoritesUseCase(sl<ProductRepository>()),
  );

  // Blocs
  sl.registerFactory<ProductsBloc>(
    () => ProductsBloc(
      sl<GetProductsUseCase>(),
      sl<AddToFavoritesUseCase>(),
      sl<RemoveFromFavoritesUseCase>(),
      sl<FavoritesNotifier>(),
    ),
  );
  sl.registerFactory<CategoriesBloc>(
    () => CategoriesBloc(sl<GetCategoriesUseCase>()),
  );
  sl.registerFactory<ProductDetailsBloc>(
    () => ProductDetailsBloc(
      sl<GetProductDetailsUseCase>(),
      sl<AddToFavoritesUseCase>(),
      sl<RemoveFromFavoritesUseCase>(),
    ),
  );
  sl.registerFactory<ProfileFavoritesBloc>(
    () => ProfileFavoritesBloc(
      sl<GetFavoritesUseCase>(),
      sl<RemoveFromFavoritesUseCase>(),
      sl<FavoritesNotifier>(),
    ),
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
