import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:trax_host_portal/controller/auth_controller/auth_controller.dart';
import 'package:trax_host_portal/services/auth_services.dart';

/// Controller for managing host sign-in functionality
/// Only host users are allowed to log in to this portal
class SignInController extends GetxController {
  final AuthServices _authServices = AuthServices();
  final AuthController _authController = Get.find<AuthController>();

  // Observables
  var isLoading = false.obs;
  var isPasswordVisible = false.obs;

  // Message observables
  var successMessage = RxnString();
  var errorMessage = RxnString();

  // Auth result
  var authResult = Rxn<UserCredential>();

  // Navigation flags
  var shouldNavigateToEmailVerification = false.obs;
  var shouldNavigateToHostPerson = false.obs;

  // ─────────────────────────────────────────────
  // UI toggles
  // ─────────────────────────────────────────────

  /// Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
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

      print('Controller: Signing in host user');
      final userCredential = await _authServices.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _authController.loadUserProfile();
      authResult.value = userCredential;

      final currentUser = userCredential.user;
      final isVerified = currentUser?.emailVerified ?? false;

      // Only allow host users - log out anyone else
      final userRole = _authController.userRole.value;

      if (userRole?.name != 'host') {
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
    shouldNavigateToEmailVerification.value = false;
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
