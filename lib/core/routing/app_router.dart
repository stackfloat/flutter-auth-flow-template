import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_ecommerce_app/core/services/dependency_injection/injection_container.dart';
import 'package:furniture_ecommerce_app/features/authentication/presentation/bloc/signin/signin_bloc.dart';
import 'package:furniture_ecommerce_app/features/authentication/presentation/bloc/signup/signup_bloc.dart';
import 'package:furniture_ecommerce_app/features/authentication/presentation/screens/signin_screen.dart';
import 'package:furniture_ecommerce_app/features/authentication/presentation/screens/signup_screen.dart';
import 'package:furniture_ecommerce_app/features/home/presentation/screens/home_screen.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/signin',
  routes: [
    GoRoute(
      path: '/signin',
      name: 'signin',
      builder: (context, state) => BlocProvider(
        create: (context) => sl<SigninBloc>(),
        child: const LoginScreen(),
      ),
    ),
    GoRoute(
      path: '/signup',
      name: 'signup',
      builder: (context, state) => BlocProvider(
        create: (context) => sl<SignupBloc>(),
        child: const SignupScreen(),
      ),
    ),
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);
