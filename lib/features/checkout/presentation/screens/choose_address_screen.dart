import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:furniture_ecommerce_app/core/common/widgets/elevated_button_widget.dart';
import 'package:furniture_ecommerce_app/core/theme/app_colors.dart';
import 'package:furniture_ecommerce_app/features/checkout/presentation/bloc/choose_address_bloc.dart';
import 'package:go_router/go_router.dart';

class ChooseAddressScreen extends StatelessWidget {
  const ChooseAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Checkout'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 20.h),
          child: Column(
            children: [
              const _CheckoutProgress(),
              SizedBox(height: 28.h),
              Row(
                children: [
                  Text(
                    'Address',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      context.pushNamed('add-new-address').then((_) {
                        context.read<ChooseAddressBloc>().add(const GetAddressesEvent());
                      });
                    },
                    child: Text(
                      'NEW ADDRESS',
                      style: textTheme.labelLarge?.copyWith(
                        color: Colors.black,
                        letterSpacing: 0.3,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: BlocBuilder<ChooseAddressBloc, ChooseAddressState>(
                  builder: (context, state) {
                    if (state is ChooseAddressLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is ChooseAddressFailure) {
                      return Center(
                        child: Text(
                          state.message,
                          style: textTheme.bodyMedium?.copyWith(
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    if (state is ChooseAddressLoaded) {
                      if (state.addresses.isEmpty) {
                        return Center(
                          child: Text(
                            'No addresses yet. Add a new address.',
                            style: textTheme.bodyMedium?.copyWith(
                              color: Colors.black54,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }
                      return ListView.separated(
                        padding: EdgeInsets.zero,
                        itemCount: state.addresses.length,
                        separatorBuilder: (_, __) => Divider(
                          height: 24.h,
                          color: AppColors.border.withValues(alpha: 0.6),
                        ),
                        itemBuilder: (context, index) {
                          final address = state.addresses[index];
                          final isSelected = index == state.selectedIndex;
                          return InkWell(
                            borderRadius: BorderRadius.circular(12.r),
                            onTap: () {
                              context
                                  .read<ChooseAddressBloc>()
                                  .add(AddressSelectedEvent(index));
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 6.h),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          address.name,
                                          style: textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(height: 8.h),
                                        Text(
                                          address.formattedAddress,
                                          style: textTheme.bodyMedium?.copyWith(
                                            height: 1.2,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        if (address.phone.isNotEmpty) ...[
                                          SizedBox(height: 4.h),
                                          Text(
                                            address.phone,
                                            style: textTheme.bodySmall?.copyWith(
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  _AddressSelector(isSelected: isSelected),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: BlocBuilder<ChooseAddressBloc, ChooseAddressState>(
                  builder: (context, state) {
                    final canContinue = state is ChooseAddressLoaded &&
                        state.addresses.isNotEmpty &&
                        state.selectedIndex != null;
                    return ElevatedButtonWidget(
                      buttonLabel: 'Continue',
                      enabled: canContinue,
                      onPressEvent: () => context.pushNamed('payment-completed'),
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

class _CheckoutProgress extends StatelessWidget {
  const _CheckoutProgress();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Row(
          children: [
            const _StepDot(isActive: true),
            Expanded(
              child: Divider(
                color: AppColors.border,
                thickness: 1,
                indent: 4.w,
                endIndent: 4.w,
              ),
            ),
            const _StepDot(isActive: false),
            Expanded(
              child: Divider(
                color: AppColors.border,
                thickness: 1,
                indent: 4.w,
                endIndent: 4.w,
              ),
            ),
            const _StepDot(isActive: false),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: Text(
                'Personal Info',
                style: textTheme.bodyMedium?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Payment',
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Confirmation',
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StepDot extends StatelessWidget {
  final bool isActive;
  const _StepDot({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16.w,
      height: 16.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isActive ? Colors.black : AppColors.border,
          width: 1.5,
        ),
      ),
      child: isActive
          ? Center(
              child: Container(
                width: 8.w,
                height: 8.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                ),
              ),
            )
          : null,
    );
  }
}

class _AddressSelector extends StatelessWidget {
  final bool isSelected;
  const _AddressSelector({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 4.h),
      width: 22.w,
      height: 22.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? Colors.black : AppColors.border,
          width: isSelected ? 2 : 1.6,
        ),
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: 10.w,
                height: 10.w,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
              ),
            )
          : null,
    );
  }
}
