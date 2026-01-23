import 'package:flutter/material.dart';
import 'package:trax_host_portal/helper/app_padding.dart';
import 'package:trax_host_portal/theme/app_colors.dart';
import 'package:trax_host_portal/utils/enums/sizes.dart';

class RightSectionContainer extends StatelessWidget {
  final Widget child;

  const RightSectionContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width < 600
          ? MediaQuery.of(context).size.width
          : 600,
      child: Container(
        color: AppColors.white,
        child: Padding(
          // padding: AppPadding.vertical(context, paddingType: Sizes.xl),
          padding: AppPadding.all(context, paddingType: Sizes.xxl),
          child: child,
        ),
      ),
    );
  }
}
