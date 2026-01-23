import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trax_host_portal/controller/guest_controller.dart/respond_controller.dart';
import 'package:trax_host_portal/helper/app_border_radius.dart';
import 'package:trax_host_portal/helper/app_padding.dart';
import 'package:trax_host_portal/theme/app_colors.dart';
import 'package:trax_host_portal/utils/enums/sizes.dart';
import 'package:trax_host_portal/view/guest/widgets/responses_table.dart';

class ThirdStepContent extends StatelessWidget {
  final RespondController respondController;
  const ThirdStepContent({super.key, required this.respondController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: AppBorderRadius.radius(context, size: Sizes.sm),
            side: BorderSide(
              color: AppColors.primaryOld(context).withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Padding(
            padding: AppPadding.all(context, paddingType: Sizes.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Obx(() {
                  final responses =
                      respondController.getAllResponsesAsTableRows();
                  //Content
                  return ResponsesTable(responses: responses);
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
