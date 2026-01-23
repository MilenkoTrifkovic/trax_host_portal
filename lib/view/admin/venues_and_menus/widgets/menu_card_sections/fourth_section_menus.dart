import 'package:flutter/material.dart';
import 'package:trax_host_portal/helper/app_padding.dart';
import 'package:trax_host_portal/models/menu_item.dart';
import 'package:trax_host_portal/theme/app_colors.dart';
import 'package:trax_host_portal/utils/enums/sizes.dart';

class FourthSectionMenus extends StatelessWidget {
  final MenuItem menu;
  final VoidCallback? onPressed;
  const FourthSectionMenus({
    super.key,
    required this.menu,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
            padding: AppPadding.right(context, paddingType: Sizes.xs),
            child: IconButton(
              onPressed: onPressed,
              icon: Icon(Icons.delete, color: AppColors.inputError),
            ))
      ],
    );
  }
}
