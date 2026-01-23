import 'package:flutter/material.dart';
import 'package:trax_host_portal/helper/app_padding.dart';
import 'package:trax_host_portal/models/user_model.dart';
import 'package:trax_host_portal/theme/app_colors.dart';
import 'package:trax_host_portal/utils/enums/sizes.dart';
import 'package:trax_host_portal/widgets/dialogs/dialogs.dart';

class FourthSectionUserCard extends StatelessWidget {
  final UserModel user;
  final VoidCallback? onPressed;
  final VoidCallback? onEdit;
  const FourthSectionUserCard({
    super.key,
    required this.user,
    required this.onPressed,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
            padding: AppPadding.right(context, paddingType: Sizes.xs),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    onEdit!();
                  },
                  icon: Icon(Icons.edit, color: AppColors.primary),
                ),
                IconButton(
                  onPressed: () {
                    Dialogs.showConfirmationDialog(
                        context, 'Are you sure you want to delete this user?',
                        () {
                      if (onPressed != null) {
                        onPressed!();
                      }
                    });
                  },
                  icon: Icon(Icons.delete, color: AppColors.inputError),
                ),
              ],
            ))
      ],
    );
  }
}
