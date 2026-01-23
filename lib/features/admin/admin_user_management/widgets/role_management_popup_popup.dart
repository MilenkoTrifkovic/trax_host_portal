import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trax_host_portal/features/admin/admin_user_management/controllers/admin_user_list_controller.dart';
import 'package:trax_host_portal/theme/app_font_weight.dart';
import 'package:trax_host_portal/theme/styled_app_text.dart';
import 'package:trax_host_portal/helper/app_padding.dart';
import 'package:trax_host_portal/helper/app_spacing.dart';
import 'package:trax_host_portal/utils/enums/sizes.dart';
import 'package:trax_host_portal/utils/enums/user_type.dart';
import 'package:trax_host_portal/utils/navigation/routes.dart';
import 'package:trax_host_portal/widgets/app_dropdown_menu.dart';
import 'package:trax_host_portal/widgets/app_primary_button.dart';
import 'package:trax_host_portal/widgets/app_text_input_field.dart';
import 'package:trax_host_portal/widgets/dialogs/app_dialog.dart';
import 'package:trax_host_portal/widgets/dialog_step_header.dart';

class RoleManagementPopup extends StatelessWidget {
  final AdminUserListController controller;
  final bool isEditMode;
  const RoleManagementPopup(
      {super.key, required this.controller, this.isEditMode = false});
  @override
  Widget build(BuildContext context) {
    return AppDialog(
        content: SingleChildScrollView(
      child: Padding(
        padding: AppPadding.symmetric(
          context,
          horizontalPadding: Sizes.xxxl, // 64px on desktop
          verticalPadding: Sizes.xl, // 48px on desktop
        ),
        child: Column(
          children: [
            DialogStepHeader(
                icon: Icons.group_add,
                title: isEditMode ? 'Edit User' : 'Add User',
                description: isEditMode
                    ? 'Update the user\'s information.'
                    : 'Let\'s create a new company member.'),
            _buildMenuForm(context)
          ],
        ),
      ),
    ));
  }

  Widget _buildMenuForm(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSpacing.verticalLg(context),

            // User Email Field
            AppTextInputField(
              label: 'User Email *',
              controller: controller.email,
              hintText: 'Enter user email',
              validator: controller.validateEmail,
              // maxLength: 100,
            ),

            // Category dropdown
            Obx(() {
              // return DropdownButtonFormField<MenuCategory>(
              return AppDropdownMenu<UserRole>(
                value: controller.role.value ?? UserRole.planner,
                label: "Role *",
                items: UserRole.values
                    .map((c) => DropdownMenuItem(
                          value: c,
                          child: AppText.styledBodyLarge(
                              context, c.name.capitalize!,
                              weight: AppFontWeight.semiBold),
                        ))
                    .toList(),
                onChanged: (v) => controller.role.value = v,
                validator: (v) => v == null ? 'Role is required' : null,
              );
            }),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: AppPrimaryButton(
                    text: 'Create User',
                    onPressed: () async {
                      if (!controller.validateForm()) return;
                      popRoute(context, true);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
