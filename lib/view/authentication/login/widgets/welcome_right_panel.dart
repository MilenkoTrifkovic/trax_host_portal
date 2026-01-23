import 'package:flutter/material.dart';
import 'package:trax_host_portal/helper/app_padding.dart';
import 'package:trax_host_portal/helper/screen_size.dart';
import 'package:trax_host_portal/theme/app_colors.dart';
import 'package:trax_host_portal/theme/constants.dart';
import 'package:trax_host_portal/theme/styled_app_text.dart';
import 'package:trax_host_portal/utils/enums/sizes.dart';
import 'package:trax_host_portal/widgets/section_devider.dart';

class WelcomeRightPanel extends StatelessWidget {
  const WelcomeRightPanel({super.key});

  @override
  Widget build(BuildContext context) {
    // Only show on desktop/tablet, not on phone
    if (ScreenSize.isPhone(context)) {
      return const SizedBox.shrink();
    }

    return Expanded(
      child: Padding(
        padding: AppPadding.left(context, paddingType: Sizes.xl),
        child: Container(
          color: Colors.transparent, // Keep background transparent
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.styledHeadingLarge(
                family: Constants.font2,
                weight: FontWeight.bold,
                context,
                'Making every event spectacular',
                color: AppColors
                    .white, // White text for visibility on dark background
              ),
              SectionDivider(
                height: 30,
                thickness: 2,
                color: AppColors.white, // White divider for visibility
              ),
              AppText.styledHeadingMedium(
                weight: FontWeight.bold,
                context,
                'Making an event out of keeping track Making an event',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
