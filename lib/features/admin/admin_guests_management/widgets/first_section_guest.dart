import 'package:flutter/material.dart';
import 'package:trax_host_portal/extensions/string_extensions.dart';
import 'package:trax_host_portal/helper/app_padding.dart';
import 'package:trax_host_portal/models/guest_model.dart';
import 'package:trax_host_portal/theme/app_font_weight.dart';
import 'package:trax_host_portal/theme/styled_app_text.dart';
import 'package:trax_host_portal/utils/enums/sizes.dart';

class FirstSectionGuest extends StatelessWidget {
  final GuestModel guest;
  final VoidCallback? onPressed;
  const FirstSectionGuest({
    super.key,
    required this.guest,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
            padding: AppPadding.left(context, paddingType: Sizes.xs),
            child: AppText.styledBodyMedium(
              context,
             guest.name.capitalizeString(),
             weight: AppFontWeight.semiBold,
            ))
      ],
    );
  }
}
