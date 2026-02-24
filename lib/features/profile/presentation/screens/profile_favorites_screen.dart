import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:furniture_ecommerce_app/core/theme/app_colors.dart';
import 'package:furniture_ecommerce_app/core/theme/theme_extensions.dart';
import 'package:furniture_ecommerce_app/features/profile/presentation/bloc/profile_favorites_bloc.dart';
import 'package:furniture_ecommerce_app/features/products/presentation/widgets/product_grid_card.dart';
import 'package:go_router/go_router.dart';

class ProfileFavoritesScreen extends StatelessWidget {
  const ProfileFavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('My Favourites'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 16.h),
          child: BlocConsumer<ProfileFavoritesBloc, ProfileFavoritesState>(
            listenWhen: (previous, current) => previous.message != current.message,
            listener: (context, state) {
              final message = state.message;
              if (message == null || message.isEmpty) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message)),
              );
            },
            builder: (context, state) {
              if (state.status == ProfileFavoritesStatus.loading ||
                  state.status == ProfileFavoritesStatus.initial) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.status == ProfileFavoritesStatus.failure) {
                return Center(
                  child: Text(
                    state.message ?? 'Failed to load favorites',
                    textAlign: TextAlign.center,
                    style: context.typography.body,
                  ),
                );
              }

              if (state.products.isEmpty) {
                return Center(
                  child: Text(
                    'No favorite products yet.',
                    textAlign: TextAlign.center,
                    style: context.typography.body.copyWith(
                      color: AppColors.lightTextSecondary,
                    ),
                  ),
                );
              }

              return GridView.builder(
                itemCount: state.products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16.h,
                  crossAxisSpacing: 12.w,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (context, index) {
                  final product = state.products[index];
                  return ProductGridCard(
                    title: product.name,
                    price: product.price,
                    imagePath: product.photo,
                    isFavorite: true,
                    favoriteActionIcon: Icons.close_rounded,
                    favoriteActionIconColor: Colors.redAccent,
                    onFavoriteTap: () => context.read<ProfileFavoritesBloc>().add(
                          ProfileFavoriteRemoveRequested(productId: product.id),
                        ),
                    onTap: () => context.pushNamed(
                      'product',
                      pathParameters: {'id': product.id.toString()},
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
