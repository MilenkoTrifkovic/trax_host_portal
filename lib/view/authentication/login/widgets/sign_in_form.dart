import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trax_host_portal/controller/auth_controller/sign_in_controller.dart';
import 'package:trax_host_portal/helper/validation_helper.dart';

class SignInForm extends StatelessWidget {
  final SignInController controller;
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onSubmit;
  final VoidCallback onForgotPassword;

  const SignInForm({
    super.key,
    required this.controller,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.onSubmit,
    required this.onForgotPassword,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          // Email Field
          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'Enter your email',
            ),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: ValidationHelper.validateEmail,
          ),

          const SizedBox(height: 16),

          // Password Field
          Obx(() => TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isPasswordVisible.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: controller.togglePasswordVisibility,
                  ),
                ),
                obscureText: !controller.isPasswordVisible.value,
                textInputAction: TextInputAction.done,
                validator: ValidationHelper.validatePassword,
                onFieldSubmitted: (_) => onSubmit(),
              )),

          const SizedBox(height: 24),

          // Sign In Button
          Obx(() => SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: controller.isLoading.value ? null : onSubmit,
                  child: controller.isLoading.value
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Sign in'),
                ),
              )),

          // Forgot Password
          const SizedBox(height: 16),
          TextButton(
            onPressed: onForgotPassword,
            child: Text(
              'Forgot your password?',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
