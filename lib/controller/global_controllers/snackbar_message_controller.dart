import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trax_host_portal/main.dart';
import 'package:trax_host_portal/models/snack_bar_message.dart';
import 'package:trax_host_portal/theme/app_colors.dart';
import 'package:trax_host_portal/theme/app_font_weight.dart';
import 'package:trax_host_portal/theme/styled_app_text.dart';

/// Global controller for handling snackbar messages across the app.
class SnackbarMessageController extends GetxController {
  final message = Rxn<SnackBarMessage>();

  /// Clears the current message
  void clearMessage() {
    message.value = null;
  }

  /// Safely shows a snackbar, handling cases where no Scaffold is attached
  void _showSnackBar(SnackBar snackBar) {
    try {
      rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
    } catch (e) {
      // ScaffoldMessenger exists but no Scaffolds are attached (e.g., during navigation)
      debugPrint('Could not show snackbar: $e');
    }
  }

  /// Shows a success message
  void showSuccessMessage(String text) {
    _showSnackBar(
      SnackBar(
        content: AppText.styledBodyMedium(null, text,
            color: AppColors.white, weight: AppFontWeight.semiBold),
        backgroundColor: AppColors.success,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// Shows an error message (styled the same as success but with error color)
  void showErrorMessage(String text) {
    _showSnackBar(
      SnackBar(
        content: AppText.styledBodyMedium(null, text,
            color: AppColors.white, weight: AppFontWeight.semiBold),
        backgroundColor: AppColors.inputError,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// Shows an informational message (neutral color)
  void showInfoMessage(String text) {
    _showSnackBar(
      SnackBar(
        content: AppText.styledBodyMedium(null, text,
            color: AppColors.white, weight: AppFontWeight.semiBold),
        backgroundColor: AppColors.primaryAccent,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
