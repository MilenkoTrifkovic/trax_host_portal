import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:trax_host_portal/controller/auth_controller/auth_controller.dart';
import 'package:trax_host_portal/services/auth_services.dart';
import 'package:trax_host_portal/services/cloud_functions_services.dart';

/// Controller for managing sign-in and sign-up functionality
class SignInController extends GetxController {
  final AuthServices _authServices = AuthServices();
  final CloudFunctionsService _cloudFunctionsService =
      Get.find<CloudFunctionsService>();
  final AuthController _authController = Get.find<AuthController>();

  // Observables
  var isLoading = false.obs;
  var isSignUpMode = false.obs;
  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

  // Message observables
  var successMessage = RxnString();
  var errorMessage = RxnString();

  // Auth result
  var authResult = Rxn<UserCredential>();

  // 🔥 Navigation flags
  var shouldNavigateToEmailVerification = false.obs;
  var shouldNavigateToOrganisationInfo = false.obs;
  var shouldNavigateToHostEvents = false.obs;
  var shouldNavigateToHostPerson = false.obs;

  // ─────────────────────────────────────────────
  // UI toggles
  // ─────────────────────────────────────────────

  /// Toggle between sign-in and sign-up modes
  void toggleSignUpMode() {
    isSignUpMode.value = !isSignUpMode.value;
  }

  /// Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  /// Toggle confirm password visibility
  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  // ─────────────────────────────────────────────
  // Main auth handler
  // ─────────────────────────────────────────────

  Future<void> handleEmailPasswordAuth({
    required String email,
    required String password,
  }) async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      _resetNavigationFlags();

      UserCredential userCredential;

      if (isSignUpMode.value) {
        // ───────────── SIGN UP ─────────────
        // 🚫 DISABLE SIGN UP - Only hosts can access this portal
        _showErrorMessage('Sign up is not available. Please contact your administrator for access.');
        return;
        
        /* Original sign-up code commented out
        print('Controller: Creating admin user (signup)');
        userCredential = await _authServices.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // 1️⃣ send verification email
        await _authServices.sendEmailVerification();

        // 2️⃣ load profile (role=admin, organisationId=null)
        await _authController.loadUserProfile();

        authResult.value = userCredential;

        // 3️⃣ tell UI to go to email verification page
        shouldNavigateToEmailVerification.value = true;
        */
      } else {
        // ───────────── SIGN IN ─────────────
        print('Controller: Signing in user');
        userCredential = await _authServices.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        await _authController.loadUserProfile();
        authResult.value = userCredential;

        final currentUser = userCredential.user;
        final isVerified = currentUser?.emailVerified ?? false;

        // 🚫 ONLY ALLOW HOST USERS - Log out anyone else
        final userRole = _authController.userRole.value;
        
        if (userRole?.name != 'host') {
          // Not a host user - log them out immediately
          print('⛔ User is not a host (role: ${userRole?.name}), logging out');
          await _authController.logout();
          _showErrorMessage('Access denied. Only host users are allowed to log in.');
          return;
        }

        // Host user - check verification
        if (!isVerified) {
          shouldNavigateToEmailVerification.value = true;
        } else {
          // Verified host -> go to host person portal
          shouldNavigateToHostPerson.value = true;
        }
      }
    } catch (e) {
      print('Controller: Error occurred: $e');
      _showErrorMessage(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ─────────────────────────────────────────────
  // Forgot password
  // ─────────────────────────────────────────────

  Future<void> handleForgotPassword(String email) async {
    final trimmed = email.trim();
    if (trimmed.isEmpty) {
      _showErrorMessage('Please enter your email address first');
      return;
    }

    try {
      await _authServices.sendPasswordResetEmail(trimmed);
      _showSuccessMessage('Password reset email sent! Check your inbox.');
    } catch (e) {
      _showErrorMessage(e.toString());
    }
  }

  // ─────────────────────────────────────────────
  // Navigation flags helpers
  // ─────────────────────────────────────────────

  void _resetNavigationFlags() {
    shouldNavigateToHostEvents.value = false;
    shouldNavigateToEmailVerification.value = false;
    shouldNavigateToOrganisationInfo.value = false;
    shouldNavigateToHostPerson.value = false;
  }

  void clearNavigationFlags() {
    _resetNavigationFlags();
    authResult.value = null;
  }

  // ─────────────────────────────────────────────
  // Message helpers
  // ─────────────────────────────────────────────

  void _showSuccessMessage(String message) {
    successMessage.value = message;
  }

  void _showErrorMessage(String message) {
    errorMessage.value = message;
  }

  void clearSuccessMessage() {
    successMessage.value = null;
  }

  void clearErrorMessage() {
    errorMessage.value = null;
  }
}
