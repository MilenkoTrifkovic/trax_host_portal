import 'package:flutter/material.dart';
import 'package:trax_host_portal/controller/guest_controller.dart/guest_controller.dart';
import 'package:trax_host_portal/helper/app_decoration.dart';
import 'package:trax_host_portal/helper/app_padding.dart';
import 'package:trax_host_portal/theme/app_colors.dart';
import 'package:trax_host_portal/theme/styled_app_text.dart';
import 'package:trax_host_portal/utils/enums/sizes.dart';
import 'package:trax_host_portal/utils/navigation/app_routes.dart';
import 'package:trax_host_portal/utils/navigation/routes.dart';
import 'package:trax_host_portal/utils/styled_buttons/styled_text_button.dart';
import 'package:trax_host_portal/view/guest/widgets/guest_responses_modal.dart';

class RespondToInviteButton extends StatelessWidget {
  final GuestController guestController;
  final bool hasResponse;
  const RespondToInviteButton(
      {super.key, required this.guestController, required this.hasResponse});

  final String viewRespond = 'View Response';
  final String respond = 'Respond to Invite';
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPadding.vertical(context, paddingType: Sizes.md),
      decoration: AppDecorations.bottomStickyButtonDecoration(context),
      child: Center(
        child: hasResponse
            ? StyledTextButton(
                onPressed: () async {
                  await GuestResponsesModal.show(context,
                      guestController: guestController,
                      responses: guestController.responses,
                      menuItems: guestController.eventMenus);
                },
                text: viewRespond)
            : guestController.rsvpDeadlineValid()
                ? StyledTextButton(
                    onPressed: () {
                      pushAndRemoveAllRoute(AppRoute.guestEventRespond, context,
                          extra: guestController.selectedEvent.value,
                          urlParam:
                              guestController.selectedEvent.value.eventId);
                    },
                    text: respond)
                : AppText.styledBodyLarge(context,
                    'RSVP Deadline Was ${guestController.rsvpDeadline()}',
                    weight: FontWeight.bold, color: AppColors.error(context)),
      ),
    );
  }
}
