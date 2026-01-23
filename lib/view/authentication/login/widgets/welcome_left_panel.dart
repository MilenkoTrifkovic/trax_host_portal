import 'package:flutter/material.dart';
import 'package:trax_host_portal/view/authentication/login/sign_in_screen.dart';

class WelcomeLeftPanel extends StatelessWidget {
  const WelcomeLeftPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 400,
          ),
          child: const SignInScreenWidget(),
        ),
      ),
    );
  }
}
