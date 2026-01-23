import 'package:flutter/material.dart';
import 'package:trax_host_portal/theme/app_colors.dart';
import 'package:trax_host_portal/theme/styled_app_text.dart';
import 'package:trax_host_portal/helper/app_spacing.dart';
import 'package:trax_host_portal/utils/navigation/app_routes.dart';
import 'package:trax_host_portal/utils/constantsOld.dart';
import 'package:trax_host_portal/utils/navigation/routes.dart';

AppBar welcomeAppBar(BuildContext context) {
  return AppBar(
    automaticallyImplyLeading: false,
    toolbarHeight: 70,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            pushAndRemoveAllRoute(AppRoute.welcome, context);
          },
          child: Container(
            margin: const EdgeInsets.only(top: 20, left: 10),
            child: Image.asset(
              ConstantsOld.lightLogo,
              height: 50,
              color: AppColors.primaryOld(context),
            ),
          ),
        ),
        SizedBox(
          height: 50,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        pushAndRemoveAllRoute(AppRoute.aboutView, context);
                      },
                      child: AppText.styledBodyMedium(context, 'About',
                          color: AppColors.primaryOld(context),
                          weight: FontWeight.bold)),
                  AppSpacing.horizontalXs(context),
                  AppText.styledBodyMedium(context, '|',
                      color: AppColors.primaryOld(context),
                      weight: FontWeight.bold),
                  AppSpacing.horizontalXs(context),
                  GestureDetector(
                      onTap: () {
                        pushAndRemoveAllRoute(AppRoute.contactView, context);
                      },
                      child: AppText.styledBodyMedium(context, 'Contact',
                          color: AppColors.primaryOld(context),
                          weight: FontWeight.bold)),
                ],
              )
            ],
          ),
        )
      ],
    ),
  );
}
