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
import 'package:furniture_ecommerce_app/features/home/presentation/screens/home_screen.dart';
import 'package:furniture_ecommerce_app/features/products/presentation/screens/products_screen.dart';
import 'package:furniture_ecommerce_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:furniture_ecommerce_app/features/settings/presentation/screens/settings_screen.dart';
import 'package:go_router/go_router.dart';

// Define public routes (routes that don't require authentication)
const _publicRoutes = <String>{'/signin', '/signup'};

GoRouter createRouter({
  required AuthBloc authBloc,
  required String initialLocation,
}) {
  return GoRouter(
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    initialLocation: initialLocation,
    errorBuilder: (context, state) => NotFoundScreen(
      error: state.error,
      location: state.uri.toString(),
    ),
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

      // ------------------ PROTECTED ROUTES ------------------
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
                builder: (_, __) => const HomeScreen(),
              ),
            ],
          ),

          // ------------------ PRODUCTS ------------------
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/products',
                name: 'products',
                builder: (_, __) => const ProductsScreen(),
              ),
            ],
          ),

          // ------------------ CART ------------------
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/cart',
                name: 'cart',
                builder: (_, __) => const CartScreen(),
              ),
            ],
          ),

          // ------------------ PROFILE ------------------
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                name: 'profile',
                builder: (_, __) => const ProfileScreen(),
              ),
            ],
          ),

          // ------------------ SETTINGS ------------------
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                name: 'settings',
                builder: (_, __) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
