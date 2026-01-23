import 'package:flutter/material.dart';
import 'package:trax_host_portal/helper/app_padding.dart';
import 'package:trax_host_portal/models/user_model.dart';
import 'package:trax_host_portal/theme/app_colors.dart';
import 'package:trax_host_portal/theme/app_font_weight.dart';
import 'package:trax_host_portal/theme/styled_app_text.dart';
import 'package:trax_host_portal/utils/enums/sizes.dart';

class FirstSectionUserCard extends StatelessWidget {
  final UserModel user;

  const FirstSectionUserCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.all(context, paddingType: Sizes.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: AppPadding.horizontal(context, paddingType: Sizes.sm),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.styledBodyLarge(
                    context,
                    user.email,
                    weight: FontWeight.bold,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // AppSpacing.horizontalXxs(context),
                  AppText.styledBodyMedium(
                    context,
                    color: AppColors.textMuted,
                    user.role.name,
                    weight: AppFontWeight.semiBold,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
