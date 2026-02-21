import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_ecommerce_app/core/common/widgets/main_scaffold.dart';
import 'package:furniture_ecommerce_app/core/routing/go_router_refresh_stream.dart';
import 'package:furniture_ecommerce_app/core/common/screens/not_found_screen.dart';
import 'package:furniture_ecommerce_app/core/services/dependency_injection/injection_container.dart';
import 'package:furniture_ecommerce_app/features/authentication/presentation/bloc/auth/auth_bloc.dart';
import 'package:furniture_ecommerce_app/features/authentication/presentation/bloc/auth/auth_state.dart';
import 'package:furniture_ecommerce_app/features/authentication/presentation/bloc/signin/signin_bloc.dart';
import 'package:furniture_ecommerce_app/features/authentication/presentation/bloc/signup/signup_bloc.dart';
import 'package:furniture_ecommerce_app/features/authentication/presentation/screens/signin_screen.dart';
import 'package:furniture_ecommerce_app/features/authentication/presentation/screens/signup_screen.dart';
import 'package:furniture_ecommerce_app/features/cart/presentation/screens/cart_screen.dart';
import 'package:furniture_ecommerce_app/features/checkout/presentation/screens/add_new_address_screen.dart';
import 'package:furniture_ecommerce_app/features/checkout/presentation/screens/choose_address_screen.dart';
import 'package:furniture_ecommerce_app/features/checkout/presentation/screens/payment_completed_screen.dart';
import 'package:furniture_ecommerce_app/features/home/presentation/screens/home_screen.dart';
import 'package:furniture_ecommerce_app/features/products/presentation/screens/categories_screen.dart';
import 'package:furniture_ecommerce_app/features/products/presentation/screens/product_screen.dart';
import 'package:furniture_ecommerce_app/features/products/presentation/screens/products_screen.dart';
import 'package:furniture_ecommerce_app/features/products/presentation/bloc/categories_bloc.dart';
import 'package:furniture_ecommerce_app/features/products/presentation/bloc/product_details_bloc.dart';
import 'package:furniture_ecommerce_app/features/products/presentation/bloc/products_bloc.dart';
import 'package:furniture_ecommerce_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:furniture_ecommerce_app/features/search/presentation/screens/search_screen.dart';
import 'package:go_router/go_router.dart';

// Define public routes (routes that don't require authentication)
const _publicRoutes = <String>{'/signin', '/signup'};

GoRouter createRouter({
  required AuthBloc authBloc,
  required String initialLocation,
}) {
  Widget buildProductsScreen(GoRouterState state) {
    final categoryId = state.uri.queryParameters['category_id'] ?? '';
    return BlocProvider(
      create: (_) => sl<ProductsBloc>()
        ..add(
          GetProductsEvent(
            isInitialLoad: true,
            categoryId: categoryId,
          ),
        ),
      child: const ProductsScreen(),
    );
  }

  return GoRouter(
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    initialLocation: initialLocation,
    errorBuilder: (context, state) =>
        NotFoundScreen(error: state.error, location: state.uri.toString()),
    redirect: (context, state) {
      final authStatus = authBloc.state.status;
      final currentLocation = state.uri.path;
      final isPublicRoute = _publicRoutes.contains(currentLocation);
      final isUnauthenticatedFlow =
          authStatus == AuthStatus.unauthenticated ||
          authStatus == AuthStatus.accountDisabled;

      if (isUnauthenticatedFlow && !isPublicRoute) {
        return '/signin';
      }

      if (authStatus == AuthStatus.authenticated && isPublicRoute) {
        return '/';
      }

      return null;
    },
    routes: [
      // ------------------ PUBLIC ROUTES ------------------
      GoRoute(
        path: '/signin',
        name: 'signin',
        builder: (context, state) => BlocProvider(
          create: (_) => sl<SigninBloc>(),
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => BlocProvider(
          create: (_) => sl<SignupBloc>(),
          child: const SignupScreen(),
        ),
      ),

      // ------------------ FULL-SCREEN ROUTES (no bottom nav) ------------------
      GoRoute(
        path: '/categories',
        name: 'categories',
        builder: (_, _) => BlocProvider(
          create: (_) => sl<CategoriesBloc>()..add(const GetCategoriesEvent()),
          child: const CategoriesScreen(),
        ),
      ),
      GoRoute(
        path: '/product/:id',
        name: 'product',
        builder: (context, state) {
          final rawId = state.pathParameters['id'] ?? '';
          final productId = int.tryParse(rawId) ?? 0;
          return BlocProvider(
            create: (_) => sl<ProductDetailsBloc>()
              ..add(GetProductDetailsEvent(productId: productId)),
            child: ProductScreen(productId: rawId),
          );
        },
      ),
      GoRoute(
        path: '/products-preview',
        name: 'products-preview',
        builder: (_, state) => buildProductsScreen(state),
      ),
      GoRoute(
        path: '/cart-preview',
        name: 'cart-preview',
        builder: (_, _) => const CartScreen(),
      ),

      GoRoute(
        path: '/checkout/choose-address',
        name: 'choose-address',
        builder: (_, _) => const ChooseAddressScreen(),
      ),
      GoRoute(
        path: '/checkout/add-new-address',
        name: 'add-new-address',
        builder: (_, _) => const AddNewAddressScreen(),
      ),
      GoRoute(
        path: '/checkout/payment-completed',
        name: 'payment-completed',
        builder: (_, _) => const PaymentCompletedScreen(),
      ),

      // ------------------ PROTECTED ROUTES (with bottom nav) ------------------
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScaffold(navigationShell: navigationShell);
        },
        branches: [
          // ------------------ HOME ------------------
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                name: 'home',
                builder: (_, _) => const HomeScreen(),
              ),
            ],
          ),

          // ------------------ PRODUCTS ------------------
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/products',
                name: 'products',
                builder: (_, state) => buildProductsScreen(state),
              ),
            ],
          ),

          // ------------------ CART ------------------
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/cart',
                name: 'cart',
                builder: (_, _) => const CartScreen(),
              ),
            ],
          ),

          // ------------------ PROFILE ------------------
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/search',
                name: 'search',
                builder: (_, _) => const SearchScreen(),
              ),
            ],
          ),

          // ------------------ SETTINGS ------------------
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                name: 'profile',
                builder: (_, _) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
