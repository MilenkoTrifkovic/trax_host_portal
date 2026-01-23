import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trax_host_portal/controller/auth_controller/auth_controller.dart';
import 'package:trax_host_portal/helper/app_padding.dart';
import 'package:trax_host_portal/utils/enums/sizes.dart';
import 'package:trax_host_portal/view/authentication/login/widgets/welcome_left_panel.dart';
import 'package:trax_host_portal/view/authentication/login/widgets/welcome_right_panel.dart';
import 'package:trax_host_portal/widgets/background_scaffold.dart';

/// The welcome screen of the application.
/// Provides login functionality with role selection (host/planner).
/// TODO Redefine UI .
class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  late AuthController authController;

  @override
  void initState() {
    authController = Get.find<AuthController>();
    super.initState();
  }

  /// Builds the welcome screen with login form and role selection
  @override
  Widget build(BuildContext context) {
    return BackgroundScaffold(
      child: SizedBox.expand(
        child: Padding(
          padding: AppPadding.all(context, paddingType: Sizes.xl),
          child: LayoutBuilder(builder: (context, constraints) {
            return const Row(
              children: [
                // Left Panel - Sign In Screen
                WelcomeLeftPanel(),
                // Right Panel - Marketing Content
                WelcomeRightPanel(),
              ],
            );
          }),
        ),
      ),
    );
  }
}
