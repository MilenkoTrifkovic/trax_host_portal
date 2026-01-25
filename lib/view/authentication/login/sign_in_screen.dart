import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trax_host_portal/controller/auth_controller/sign_in_controller.dart';
import 'package:trax_host_portal/utils/navigation/app_routes.dart';
import 'package:trax_host_portal/utils/navigation/routes.dart';
import 'package:trax_host_portal/controller/global_controllers/snackbar_message_controller.dart';
import 'package:trax_host_portal/view/authentication/login/widgets/sign_in_header.dart';
import 'package:trax_host_portal/view/authentication/login/widgets/sign_in_form.dart';

/// Host Portal Sign In Screen
/// Only host users can log in to this portal
class SignInScreenWidget extends StatefulWidget {
  const SignInScreenWidget({super.key});

  @override
  State<SignInScreenWidget> createState() => _SignInScreenWidgetState();
}

class _SignInScreenWidgetState extends State<SignInScreenWidget> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final SnackbarMessageController snackbarController;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    snackbarController = Get.find<SnackbarMessageController>();
  }

  Future<void> _handleSignIn(SignInController controller) async {
    if (!_formKey.currentState!.validate()) return;

    await controller.handleEmailPasswordAuth(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  Future<void> _handleForgotPassword(SignInController controller) async {
    await controller.handleForgotPassword(_emailController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignInController());

    _setupListeners(controller, context);

    return SingleChildScrollView(
      child: SizedBox(
        width: 400,
        child: Card(
          elevation: 0,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                SignInHeader(controller: controller),

                // Form Section
                SignInForm(
                  controller: controller,
                  formKey: _formKey,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  onSubmit: () => _handleSignIn(controller),
                  onForgotPassword: () => _handleForgotPassword(controller),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Setup all GetX listeners for messages and navigation
  void _setupListeners(SignInController controller, BuildContext context) {
    // Watch for success messages
    ever(controller.successMessage, (String? message) {
      if (message != null && message.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          snackbarController.showSuccessMessage(message);
          controller.clearSuccessMessage();
        });
      }
    });

    // Watch for error messages
    ever(controller.errorMessage, (String? message) {
      if (message != null && message.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          snackbarController.showErrorMessage(message);
          controller.clearErrorMessage();
        });
      }
    });

    // Navigate to email verification if not verified
    ever(controller.shouldNavigateToEmailVerification, (bool shouldNavigate) {
      if (shouldNavigate) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          print('UI: Navigating to email verification');
          pushAndRemoveAllRoute(AppRoute.emailVerification, context);
          controller.clearNavigationFlags();
        });
      }
    });

    // Navigate to host person portal for verified host users
    ever(controller.shouldNavigateToHostPerson, (bool shouldNavigate) {
      if (shouldNavigate) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          print('UI: Navigating to host person portal');
          pushAndRemoveAllRoute(AppRoute.hostPersonEvents, context);
          controller.clearNavigationFlags();
        });
      }
    });
  }
}
