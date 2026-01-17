import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_ecommerce_app/core/common/widgets/elevated_button_widget.dart';
import 'package:furniture_ecommerce_app/core/common/widgets/error_text_widget.dart';
import 'package:furniture_ecommerce_app/core/common/widgets/text_field_widget.dart';
import 'package:furniture_ecommerce_app/features/authentication/presentation/bloc/auth/auth_bloc.dart';
import 'package:furniture_ecommerce_app/features/authentication/presentation/bloc/auth/auth_event.dart';
import 'package:furniture_ecommerce_app/features/authentication/presentation/bloc/signup/signup_bloc.dart';
import 'package:furniture_ecommerce_app/features/authentication/presentation/bloc/signup/signup_event.dart';
import 'package:furniture_ecommerce_app/features/authentication/presentation/bloc/signup/signup_state.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return BlocListener<SignupBloc, SignupState>(
              listenWhen: (previous, current) =>
                  previous.status != current.status &&
                  current.status == SignupStatus.success,
              listener: (context, state) {
                context.read<AuthBloc>().add(
                  LoggedIn(state.user!),
                );
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 32,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),

                        // Title
                        Text(
                          "Create an Account",
                          style: textTheme.headlineLarge,
                        ),
                        const SizedBox(height: 8),

                        // Subtitle
                        Text(
                          "Enter your details to register",
                          style: textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 32),

                        const _SignupNameField(),
                        const SizedBox(height: 20),

                        const _SignupEmailField(),
                        const SizedBox(height: 20),

                        const _SignupPasswordField(),
                        const SizedBox(height: 32),

                        const _SignupConfirmPasswordField(),
                        const SizedBox(height: 32),

                        const _SignupGlobalErrors(),

                        // Login button
                        const SizedBox(
                          width: double.infinity,
                          child: _SignupSubmitButton(),
                        ),

                        const SizedBox(height: 22),
                        const Spacer(), // Now works with IntrinsicHeight
                        // Sign up link at bottom
                        Center(
                          child: GestureDetector(
                            onTap: () => context.pushNamed('signin'),
                            child: Text.rich(
                              TextSpan(
                                style: textTheme.bodyMedium,
                                children: [
                                  const TextSpan(
                                    text: "Already have an account? ",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  TextSpan(
                                    text: "Sign In",
                                    style: textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SignupNameField extends StatelessWidget {
  const _SignupNameField();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final state = context.select((SignupBloc bloc) => (
          bloc.state.formSubmitted,
          bloc.state.errors.name,
        ));
    final formSubmitted = state.$1;
    final nameError = state.$2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Name", style: textTheme.labelLarge),
        const SizedBox(height: 8),
        TextFieldWidget(
          keyboardType: TextInputType.name,
          onChanged: (value) =>
              context.read<SignupBloc>().add(NameChanged(value)),
          errorMessage: formSubmitted ? nameError : null,
        ),
      ],
    );
  }
}

class _SignupEmailField extends StatelessWidget {
  const _SignupEmailField();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final state = context.select((SignupBloc bloc) => (
          bloc.state.formSubmitted,
          bloc.state.errors.email,
        ));
    final formSubmitted = state.$1;
    final emailError = state.$2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Email Address", style: textTheme.labelLarge),
        const SizedBox(height: 8),
        TextFieldWidget(
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) =>
              context.read<SignupBloc>().add(EmailChanged(value)),
          errorMessage: formSubmitted ? emailError : null,
        ),
      ],
    );
  }
}

class _SignupPasswordField extends StatelessWidget {
  const _SignupPasswordField();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final state = context.select((SignupBloc bloc) => (
          bloc.state.formSubmitted,
          bloc.state.errors.password,
          bloc.state.revealPassword,
        ));
    final formSubmitted = state.$1;
    final passwordError = state.$2;
    final revealPassword = state.$3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Password", style: textTheme.labelLarge),
        const SizedBox(height: 8),
        TextFieldWidget(
          keyboardType: TextInputType.visiblePassword,
          isPassword: true,
          onRevealPassword: () => context
              .read<SignupBloc>()
              .add(RevealPassword(!revealPassword)),
          revealPassword: revealPassword,
          onChanged: (value) =>
              context.read<SignupBloc>().add(PasswordChanged(value)),
          errorMessage: formSubmitted ? passwordError : null,
        ),
      ],
    );
  }
}

class _SignupConfirmPasswordField extends StatelessWidget {
  const _SignupConfirmPasswordField();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final state = context.select((SignupBloc bloc) => (
          bloc.state.formSubmitted,
          bloc.state.errors.confirmPassword,
          bloc.state.revealConfirmPassword,
        ));
    final formSubmitted = state.$1;
    final confirmPasswordError = state.$2;
    final revealConfirmPassword = state.$3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Confirm Password", style: textTheme.labelLarge),
        const SizedBox(height: 8),
        TextFieldWidget(
          keyboardType: TextInputType.visiblePassword,
          revealPassword: revealConfirmPassword,
          onRevealPassword: () => context.read<SignupBloc>().add(
                RevealConfirmPassword(!revealConfirmPassword),
              ),
          isPassword: true,
          onChanged: (value) => context
              .read<SignupBloc>()
              .add(ConfirmPasswordChanged(value)),
          errorMessage: formSubmitted ? confirmPasswordError : null,
        ),
      ],
    );
  }
}

class _SignupGlobalErrors extends StatelessWidget {
  const _SignupGlobalErrors();

  @override
  Widget build(BuildContext context) {
    final serverError = context.select(
      (SignupBloc bloc) => bloc.state.serverError,
    );

    if (serverError == null) {
      return const SizedBox.shrink();
    }

    return ErrorTextWidget(errorMessage: serverError);
  }
}

class _SignupSubmitButton extends StatelessWidget {
  const _SignupSubmitButton();

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select(
      (SignupBloc bloc) => bloc.state.status == SignupStatus.loading,
    );

    return ElevatedButtonWidget(
      buttonLabel: 'Sign Up',
      isLoading: isLoading,
      onPressEvent: () {
        context.read<SignupBloc>().add(const SignupSubmitted());
      },
    );
  }
}
