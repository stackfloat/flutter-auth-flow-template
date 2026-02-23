import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:furniture_ecommerce_app/core/common/widgets/elevated_button_widget.dart';
import 'package:furniture_ecommerce_app/core/common/widgets/error_text_widget.dart';
import 'package:furniture_ecommerce_app/core/common/widgets/labeled_input_field_widget.dart';
import 'package:furniture_ecommerce_app/core/theme/app_colors.dart';
import 'package:furniture_ecommerce_app/features/checkout/presentation/bloc/add_new_address_bloc.dart';

class AddNewAddressScreen extends StatelessWidget {
  const AddNewAddressScreen({super.key});

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
      body: BlocListener<AddNewAddressBloc, AddNewAddressState>(
        listenWhen: (previous, current) =>
            previous.status != current.status &&
            current.status == AddNewAddressStatus.success,
        listener: (context, state) => Navigator.of(context).maybePop(),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 20.h),
            child: Column(
              children: [
                const _CheckoutProgress(),
                SizedBox(height: 28.h),
                Expanded(
                  child: SingleChildScrollView(
                    child: BlocBuilder<AddNewAddressBloc, AddNewAddressState>(
                      builder: (context, state) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Deliver To',
                            style: textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 24.h),
                          const _AddressGlobalErrors(),
                          LabeledInputFieldWidget(
                            label: 'Full Name*',
                            value: state.fullName,
                            keyboardType: TextInputType.name,
                            errorMessage:
                                state.formSubmitted ? state.errors.fullName : null,
                            onChanged: (value) => context
                                .read<AddNewAddressBloc>()
                                .add(
                                  AddNewAddressFieldChanged(
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
                                .read<AddNewAddressBloc>()
                                .add(
                                  AddNewAddressFieldChanged(
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
                                .read<AddNewAddressBloc>()
                                .add(
                                  AddNewAddressFieldChanged(
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
                                      .read<AddNewAddressBloc>()
                                      .add(
                                        AddNewAddressFieldChanged(
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
                                      .read<AddNewAddressBloc>()
                                      .add(
                                        AddNewAddressFieldChanged(
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
                              context.read<AddNewAddressBloc>().add(
                                    AddNewAddressFieldChanged(
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
                                .read<AddNewAddressBloc>()
                                .add(
                                  AddNewAddressFieldChanged(
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
                ),
                BlocBuilder<AddNewAddressBloc, AddNewAddressState>(
                  builder: (context, state) => SizedBox(
                    width: double.infinity,
                    child: ElevatedButtonWidget(
                      buttonLabel: 'Save',
                      isLoading: state.status == AddNewAddressStatus.loading,
                      onPressEvent: () => context
                          .read<AddNewAddressBloc>()
                          .add(const AddNewAddressSaved()),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AddressGlobalErrors extends StatelessWidget {
  const _AddressGlobalErrors();

  @override
  Widget build(BuildContext context) {
    final serverError = context.select(
      (AddNewAddressBloc bloc) => bloc.state.serverError,
    );

    if (serverError == null) {
      return const SizedBox.shrink();
    }

    return ErrorTextWidget(errorMessage: serverError);
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
          value: value,
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
