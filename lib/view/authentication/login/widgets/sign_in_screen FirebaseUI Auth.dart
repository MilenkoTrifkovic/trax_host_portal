import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart' hide AuthController;
// import 'package:firebase_ui_auth/firebase_ui_auth.dart' hide AuthController;
import 'package:flutter/material.dart';
import 'package:trax_host_portal/helper/app_padding.dart';
import 'package:trax_host_portal/theme/constants.dart';
import 'package:trax_host_portal/utils/enums/sizes.dart';
import 'package:trax_host_portal/utils/navigation/app_routes.dart';
import 'package:trax_host_portal/utils/navigation/routes.dart';

class SignInScreenWidget extends StatelessWidget {
  const SignInScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: SignInScreen(
        providers: [
          EmailAuthProvider(),
          // GoogleProvider(clientId: Constants.webClientId),
        ],
        actions: [
          AuthStateChangeAction<UserCreated>((context, state) async {
            final user = FirebaseAuth.instance.currentUser;

            if (user != null && !user.emailVerified) {
              pushAndRemoveAllRoute(AppRoute.emailVerification, context);
            } else {
              // Navigate to host person events page
              pushAndRemoveAllRoute(AppRoute.hostPersonEvents, context);
            }
          }),
          AuthStateChangeAction<SignedIn>((context, state) async {
            final user = FirebaseAuth.instance.currentUser;

            if (user != null && !user.emailVerified) {
              pushAndRemoveAllRoute(AppRoute.emailVerification, context);
            } else {
              // Navigate to host person events page
              pushAndRemoveAllRoute(AppRoute.hostPersonEvents, context);
            }
          }),
        ],
        styles: {
          // EmailFormStyle(
          //   signInButtonVariant: ButtonVariant.filled,
          // ),
        },
        // Remove maxWidth from SignInScreen since we're handling it with ConstrainedBox
        showPasswordVisibilityToggle: true,
        headerMaxExtent: 128,

        headerBuilder: (context, constraints, _) {
          return Padding(
            padding: AppPadding.only(
              context,
              paddingType: Sizes.lg,
              left: true,
              // top: true,
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Align(
                alignment: Alignment.topLeft,
                child: Image.asset(
                  Constants.lightLogo,
                  height: 32,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
