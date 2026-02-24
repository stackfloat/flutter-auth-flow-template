import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:furniture_ecommerce_app/core/theme/app_colors.dart';
import 'package:furniture_ecommerce_app/features/checkout/domain/entities/address.dart';
import 'package:furniture_ecommerce_app/features/profile/presentation/bloc/profile_addresses_bloc.dart';
import 'package:go_router/go_router.dart';

class ProfileShippingAddressesScreen extends StatelessWidget {
  const ProfileShippingAddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFFE9ECEF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE9ECEF),
        surfaceTintColor: const Color(0xFFE9ECEF),
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Shipping Address',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.lightText,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Address',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.lightText,
                ),
              ),
              SizedBox(height: 14.h),
              Expanded(
                child: BlocBuilder<ProfileAddressesBloc, ProfileAddressesState>(
                  builder: (context, state) {
                    if (state.listStatus == ProfileAddressesStatus.loading ||
                        state.listStatus == ProfileAddressesStatus.initial) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state.listStatus == ProfileAddressesStatus.failure) {
                      return Center(
                        child: Text(
                          state.listError ?? 'Failed to load addresses',
                          textAlign: TextAlign.center,
                          style: textTheme.bodyMedium?.copyWith(color: Colors.red),
                        ),
                      );
                    }
                    if (state.addresses.isEmpty) {
                      return Center(
                        child: Text(
                          'No saved addresses yet.',
                          textAlign: TextAlign.center,
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.lightTextSecondary,
                          ),
                        ),
                      );
                    }
                    return ListView.separated(
                      itemCount: state.addresses.length,
                      separatorBuilder: (_, index) => SizedBox(height: 14.h),
                      itemBuilder: (context, index) {
                        final address = state.addresses[index];
                        return _AddressCard(
                          address: address,
                          onTap: () async {
                            await context.pushNamed(
                              'profile-edit-address',
                              pathParameters: {'id': address.id.toString()},
                            );
                            if (!context.mounted) return;
                            context.read<ProfileAddressesBloc>().add(
                                  const ProfileAddressesLoadRequested(),
                                );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final Address address;
  final VoidCallback? onTap;

  const _AddressCard({required this.address, this.onTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            address.name,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.lightText,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            address.formattedAddress,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.lightTextSecondary,
              height: 1.35,
            ),
          ),
          if (address.phone.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(
              address.phone,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.lightText,
              ),
            ),
          ],
          if (onTap != null) ...[
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.edit_outlined,
                  size: 18.sp,
                  color: AppColors.lightTextSecondary,
                ),
                SizedBox(width: 4.w),
                Text(
                  'Edit',
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.lightTextSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    ),
    );
  }
}
