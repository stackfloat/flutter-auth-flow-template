import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_ecommerce_app/core/common/widgets/elevated_button_widget.dart';
import 'package:furniture_ecommerce_app/core/common/widgets/error_text_widget.dart';
import 'package:furniture_ecommerce_app/core/common/widgets/text_field_widget.dart';
import 'package:furniture_ecommerce_app/features/authentication/presentation/bloc/auth/auth_bloc.dart';
import 'package:furniture_ecommerce_app/features/authentication/presentation/bloc/auth/auth_event.dart';
import 'package:furniture_ecommerce_app/features/authentication/presentation/bloc/auth/auth_state.dart';
import 'package:furniture_ecommerce_app/features/authentication/presentation/bloc/signin/signin_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return BlocListener<SigninBloc, SigninState>(
              listenWhen: (previous, current) =>
                  previous.status != current.status &&
                  current.status == SigninStatus.success,
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
                          "Let's Sign You In.",
                          style: textTheme.headlineLarge,
                        ),
                        const SizedBox(height: 8),

                        // Subtitle
                        Text(
                          "To Continue, first Verify that it's You.",
                          style: textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 32),

                        const _SigninEmailField(),
                        const SizedBox(height: 20),

                        const _SigninPasswordField(),
                        const SizedBox(height: 32),

                        const _SigninGlobalErrors(),

                        // Login button
                        const SizedBox(
                          width: double.infinity,
                          child: _SigninSubmitButton(),
                        ),

                        const SizedBox(height: 22),
                        const Spacer(), // Now works with IntrinsicHeight
                        // Sign up link at bottom
                        Center(
                          child: GestureDetector(
                            onTap: () => context.pushNamed('signup'),
                            child: Text.rich(
                              TextSpan(
                                style: textTheme.bodyMedium,
                                children: [
                                  const TextSpan(
                                    text: "Don't have an account? ",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  TextSpan(
                                    text: "Sign Up",
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

class _SigninEmailField extends StatelessWidget {
  const _SigninEmailField();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final error = context.select(
      (SigninBloc bloc) => bloc.state.errors.email,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Email", style: textTheme.labelLarge),
        const SizedBox(height: 8),
        TextFieldWidget(
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) =>
              context.read<SigninBloc>().add(EmailChanged(value)),
          errorMessage: error,
        ),
      ],
    );
  }
}

class _SigninPasswordField extends StatelessWidget {
  const _SigninPasswordField();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final state = context.select((SigninBloc bloc) => (
          bloc.state.errors.password,
          bloc.state.revealPassword,
        ));
    final passwordError = state.$1;
    final revealPassword = state.$2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Password", style: textTheme.labelLarge),
        const SizedBox(height: 8),
        TextFieldWidget(
          keyboardType: TextInputType.visiblePassword,
          isPassword: true,
          revealPassword: revealPassword,
          onRevealPassword: () => context
              .read<SigninBloc>()
              .add(RevealPassword(!revealPassword)),
          onChanged: (value) =>
              context.read<SigninBloc>().add(PasswordChanged(value)),
          errorMessage: passwordError,
        ),
      ],
    );
  }
}

class _SigninGlobalErrors extends StatelessWidget {
  const _SigninGlobalErrors();

  @override
  Widget build(BuildContext context) {
    final accountDisabled = context.select(
      (AuthBloc bloc) => bloc.state.status == AuthStatus.accountDisabled,
    );
    final state = context.select((SigninBloc bloc) => (
          bloc.state.serverError,
          bloc.state.authError,
        ));
    final serverError = state.$1;
    final authError = state.$2;

    if (!accountDisabled && serverError == null && authError == null) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        if (accountDisabled)
          const ErrorTextWidget(
            errorMessage: 'Your account has been disabled. Contact support.',
          ),
        if (serverError != null) ErrorTextWidget(errorMessage: serverError),
        if (authError != null) ErrorTextWidget(errorMessage: authError),
      ],
    );
  }
}

class _SigninSubmitButton extends StatelessWidget {
  const _SigninSubmitButton();

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select(
      (SigninBloc bloc) => bloc.state.status == SigninStatus.loading,
    );

    return ElevatedButtonWidget(
      buttonLabel: 'Sign In',
      isLoading: isLoading,
      onPressEvent: () {
        context.read<SigninBloc>().add(const SigninSubmitted());
      },
    );
  }
}
