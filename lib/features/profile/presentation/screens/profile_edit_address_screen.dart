import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:furniture_ecommerce_app/core/common/widgets/elevated_button_widget.dart';
import 'package:furniture_ecommerce_app/core/common/widgets/error_text_widget.dart';
import 'package:furniture_ecommerce_app/core/common/widgets/labeled_input_field_widget.dart';
import 'package:furniture_ecommerce_app/core/theme/app_colors.dart';
import 'package:furniture_ecommerce_app/features/profile/presentation/bloc/profile_addresses_bloc.dart';
import 'package:go_router/go_router.dart';

class ProfileEditAddressScreen extends StatelessWidget {
  final String addressId;

  const ProfileEditAddressScreen({super.key, required this.addressId});

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
          'Edit Address',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.lightText,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocConsumer<ProfileAddressesBloc, ProfileAddressesState>(
        listenWhen: (previous, current) =>
            previous.updateStatus != current.updateStatus &&
            current.updateStatus == ProfileAddressEditStatus.success,
        listener: (context, state) => context.pop(),
        builder: (context, state) {
          if (state.editLoadStatus == ProfileAddressEditStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.editLoadStatus == ProfileAddressEditStatus.failure) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  state.editLoadError ?? 'Failed to load address',
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium?.copyWith(color: Colors.red),
                ),
              ),
            );
          }

          return SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 20.h),
              child: Column(
                children: [
                  if (state.serverError != null)
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: ErrorTextWidget(
                        errorMessage: state.serverError!,
                      ),
                    ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Edit Address',
                            style: textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.lightText,
                            ),
                          ),
                          SizedBox(height: 24.h),
                          LabeledInputFieldWidget(
                            label: 'Full Name*',
                            value: state.fullName,
                            keyboardType: TextInputType.name,
                            errorMessage:
                                state.formSubmitted ? state.errors.fullName : null,
                            onChanged: (value) => context
                                .read<ProfileAddressesBloc>()
                                .add(
                                  ProfileAddressEditFieldChanged(
                                    field: 'fullName',
                                    value: value,
                                  ),
                                ),
                          ),
                          SizedBox(height: 24.h),
                          LabeledInputFieldWidget(
                            label: 'Address*',
                            value: state.address,
                            keyboardType: TextInputType.streetAddress,
                            maxLines: 2,
                            errorMessage:
                                state.formSubmitted ? state.errors.address : null,
                            onChanged: (value) => context
                                .read<ProfileAddressesBloc>()
                                .add(
                                  ProfileAddressEditFieldChanged(
                                    field: 'address',
                                    value: value,
                                  ),
                                ),
                          ),
                          SizedBox(height: 24.h),
                          LabeledInputFieldWidget(
                            label: 'City*',
                            value: state.city,
                            keyboardType: TextInputType.streetAddress,
                            errorMessage:
                                state.formSubmitted ? state.errors.city : null,
                            onChanged: (value) => context
                                .read<ProfileAddressesBloc>()
                                .add(
                                  ProfileAddressEditFieldChanged(
                                    field: 'city',
                                    value: value,
                                  ),
                                ),
                          ),
                          SizedBox(height: 24.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: LabeledInputFieldWidget(
                                  label: 'State*',
                                  value: state.stateRegion,
                                  keyboardType: TextInputType.streetAddress,
                                  errorMessage: state.formSubmitted
                                      ? state.errors.stateRegion
                                      : null,
                                  onChanged: (value) => context
                                      .read<ProfileAddressesBloc>()
                                      .add(
                                        ProfileAddressEditFieldChanged(
                                          field: 'stateRegion',
                                          value: value,
                                        ),
                                      ),
                                ),
                              ),
                              SizedBox(width: 18.w),
                              Expanded(
                                flex: 2,
                                child: LabeledInputFieldWidget(
                                  label: 'ZIP*',
                                  value: state.zip,
                                  keyboardType: TextInputType.number,
                                  errorMessage:
                                      state.formSubmitted ? state.errors.zip : null,
                                  onChanged: (value) => context
                                      .read<ProfileAddressesBloc>()
                                      .add(
                                        ProfileAddressEditFieldChanged(
                                          field: 'zip',
                                          value: value,
                                        ),
                                      ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24.h),
                          _LabeledDropdownField(
                            label: 'Country*',
                            value: state.country,
                            options: const ['US'],
                            errorMessage:
                                state.formSubmitted ? state.errors.country : null,
                            onChanged: (value) {
                              if (value == null) return;
                              context.read<ProfileAddressesBloc>().add(
                                    ProfileAddressEditFieldChanged(
                                      field: 'country',
                                      value: value,
                                    ),
                                  );
                            },
                          ),
                          SizedBox(height: 24.h),
                          LabeledInputFieldWidget(
                            label: 'Phone Number*',
                            value: state.phoneNumber,
                            keyboardType: TextInputType.phone,
                            errorMessage: state.formSubmitted
                                ? state.errors.phoneNumber
                                : null,
                            onChanged: (value) => context
                                .read<ProfileAddressesBloc>()
                                .add(
                                  ProfileAddressEditFieldChanged(
                                    field: 'phoneNumber',
                                    value: value,
                                  ),
                                ),
                          ),
                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButtonWidget(
                      buttonLabel: 'Save',
                      isLoading: state.updateStatus == ProfileAddressEditStatus.loading,
                      onPressEvent: () => context
                          .read<ProfileAddressesBloc>()
                          .add(const ProfileAddressUpdateRequested()),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LabeledDropdownField extends StatelessWidget {
  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String?> onChanged;
  final String? errorMessage;

  const _LabeledDropdownField({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 10.h),
        DropdownButtonFormField<String>(
          value: value.isEmpty ? options.first : value,
          items: options
              .map(
                (option) => DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                ),
              )
              .toList(),
          onChanged: onChanged,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          style: textTheme.bodyLarge?.copyWith(color: Colors.black),
          decoration: InputDecoration(
            errorText: errorMessage,
            isDense: true,
            filled: false,
            contentPadding: EdgeInsets.only(bottom: 10.h),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.border.withValues(alpha: 0.75),
              ),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 1.4),
            ),
          ),
        ),
      ],
    );
  }
}
