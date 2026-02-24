import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:furniture_ecommerce_app/core/theme/app_colors.dart';
import 'package:furniture_ecommerce_app/features/authentication/presentation/bloc/auth/auth_bloc.dart';
import 'package:furniture_ecommerce_app/features/authentication/presentation/bloc/auth/auth_event.dart';
import 'package:furniture_ecommerce_app/features/profile/presentation/widgets/profile_header_card.dart';
import 'package:furniture_ecommerce_app/features/profile/presentation/widgets/profile_menu_tile.dart';
import 'package:furniture_ecommerce_app/features/profile/presentation/widgets/profile_top_bar.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12.h),
                  const ProfileTopBar(),
                  SizedBox(height: 28.h),
                  const ProfileHeaderCard(),
                  SizedBox(height: 28.h),
                  for (var i = 0; i < _menuItems.length; i++) ...[
                    ProfileMenuTile(
                      label: _menuItems[i],
                      onTap: () {
                        if (_menuItems[i] == 'Logout') {
                          context.read<AuthBloc>().add(const LoggedOut());
                        } else if (_menuItems[i] == 'My Favourites') {
                          context.pushNamed('profile-favorites');
                        } else if (_menuItems[i] == 'Shipping Address') {
                          context.pushNamed('profile-shipping-addresses');
                        }
                      },
                    ),
                    Divider(
                      height: 1,
                      color: AppColors.border.withValues(alpha: 0.5),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

const _menuItems = [
  'Edit Profile',
  'My Orders',
  'My Favourites',
  'Shipping Address',
  'Logout',
];
