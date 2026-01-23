import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trax_host_portal/controller/global_controllers/snackbar_message_controller.dart';
import 'package:trax_host_portal/features/admin/admin_user_management/controllers/admin_user_list_controller.dart';
import 'package:trax_host_portal/features/admin/admin_user_management/widgets/role_management_popup_popup.dart';
import 'package:trax_host_portal/theme/styled_app_text.dart';
import 'package:trax_host_portal/utils/loader.dart';
import 'package:trax_host_portal/widgets/app_primary_button.dart';

class AdminUserManagementHeader extends StatelessWidget {
  AdminUserManagementHeader({super.key});
  final AdminUserListController controller = AdminUserListController();
  final SnackbarMessageController snackbarMessageController =
      Get.find<SnackbarMessageController>();
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText.styledHeadingLarge(context, 'User Management'),
        Row(
          children: [
            // if (ScreenSize.isDesktop(context) == true)
            //   AppSearchInputField(
            //     hintText: 'Search users...',
            //     onChanged: (value) {
            //       menusController.filterMenus(value);
            //     },
            //   ),
            // AppSpacing.horizontalXs(context),
            AppPrimaryButton(
                icon: Icons.add,
                text: 'Add User',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return RoleManagementPopup(
                        controller: controller,
                      );
                    },
                  ).then((value) async {
                    if (value != null && value is bool && value) {
                      try {
                        showLoadingIndicator();
                        await controller.submitForm();
                      } on Exception {
                        snackbarMessageController
                            .showErrorMessage('Error creating user');
                      } finally {
                        hideLoadingIndicator();
                      }
                    }
                  });
                  // AppSpacing.horizontalXs(context),
                })
          ],
        )
      ],
    );
  }
}
