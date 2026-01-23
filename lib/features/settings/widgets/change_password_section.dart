import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trax_host_portal/features/settings/controllers/settings_screen_controller.dart';
import 'package:trax_host_portal/helper/app_spacing.dart';
import 'package:trax_host_portal/theme/app_colors.dart';
import 'package:trax_host_portal/theme/app_font_weight.dart';
import 'package:trax_host_portal/theme/styled_app_text.dart';
import 'package:trax_host_portal/widgets/app_text_input_field.dart';
import 'package:trax_host_portal/widgets/app_primary_button.dart';
import 'package:trax_host_portal/helper/validation_helper.dart';

/// Password change form used under the profile photo in the Settings page.
class ChangePasswordSection extends StatelessWidget {
  final SettingsScreenController controller;

  const ChangePasswordSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final email = FirebaseAuth.instance.currentUser?.email;

    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      padding: const EdgeInsets.all(0),
      child: Form(
        key: controller.passwordFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (email != null)
              AppText.styledBodyMedium(context, email,
                  weight: AppFontWeight.regular,
                  color: AppColors.primaryAccent),
            AppSpacing.verticalXxxs(context),
            AppTextInputField(
              label: 'Current password',
              controller: controller.currentPasswordController,
              hintText: 'Enter current password',
              obscureText: true,
              enabled: true,
              validator: (v) =>
                  ValidationHelper.validateRequired(v, 'Current password'),
            ),
            AppTextInputField(
              label: 'New password',
              controller: controller.newPasswordController,
              hintText: 'Enter new password',
              obscureText: true,
              enabled: true,
              validator: (v) => ValidationHelper.validatePassword(v),
            ),
            AppTextInputField(
              label: 'Confirm new password',
              controller: controller.confirmPasswordController,
              hintText: 'Re-enter new password',
              obscureText: true,
              enabled: true,
              validator: (v) => ValidationHelper.validateConfirmPassword(
                  v, controller.newPasswordController.text),
            ),
            const SizedBox(height: 8),
            AppPrimaryButton(
              text: 'Change password',
              onPressed: () {
                final form = controller.passwordFormKey.currentState;
                if (form == null) return;
                if (form.validate()) {
                  controller.changePassword();
                } else {
                  controller.snackbar
                      .showErrorMessage('Please fix validation errors');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
