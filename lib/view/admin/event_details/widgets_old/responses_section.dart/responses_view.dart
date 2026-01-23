import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trax_host_portal/controller/common_controllers/event_controller.dart';
import 'package:trax_host_portal/controller/admin_controllers/responses_controller.dart';
import 'package:trax_host_portal/helper/app_padding.dart';
import 'package:trax_host_portal/models/guest_response.dart';
import 'package:trax_host_portal/theme/app_colors.dart';
import 'package:trax_host_portal/theme/styled_app_text.dart';
import 'package:trax_host_portal/utils/enums/sizes.dart';
import 'package:trax_host_portal/utils/styled_buttons/styled_text_button.dart';
import 'package:trax_host_portal/view/admin/event_details/widgets_old/responses_section.dart/widgets/details_dialog.dart';
import 'package:trax_host_portal/widgets/app_future_builder.dart';

class ResponsesView extends StatefulWidget {
  const ResponsesView({super.key});

  @override
  State<ResponsesView> createState() => _ResponsesViewState();
}

class _ResponsesViewState extends State<ResponsesView> {
  final eventController = Get.find<EventController>();
  late final String eventId;
  late Future<ResponsesController> responsesControllerFuture;
  // late ResponsesController responsesController;
  @override
  void initState() {
    eventId = eventController.selectedEvent.value!.eventId!;
    responsesControllerFuture = ResponsesController.create(eventId);
    //Not a good idea to use .then here as it makes the code asynchronous
    //and we cannot use the responsesController in the build method directly. Can  fail
    // .then(
    //   (value) => responsesController = value,
    // );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppFutureBuilder(
      future: responsesControllerFuture,
      builder: (context, responsesController) {
        return Stack(
          children: [
            Column(
              children: [
                _buildHeaderRow(context),
                Expanded(
                  child: Obx(() {
                    return ListView.builder(
                      itemCount:
                          responsesController.filteredGuestResponses.length,
                      itemBuilder: (context, index) {
                        final guestResponse =
                            responsesController.filteredGuestResponses[index];
                        return _buildCard(
                            context, guestResponse, responsesController);
                      },
                    );
                  }),
                ),
              ],
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: StyledTextButton(onPressed: () {}, text: 'Export/Preview'),
            )
          ],
        );
      },
    );
  }

  Widget _buildCard(BuildContext context, GuestResponse guestResponse,
      ResponsesController responsesController) {
    return Card(
        child: Padding(
      padding: AppPadding.horizontal(context, paddingType: Sizes.sm),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: AppText.styledBodyMedium(
                context,
                guestResponse.guestId != null
                    // ? guestResponse.guestId!
                    ? responsesController.guestName(guestResponse.guestId!)
                    : guestResponse.guestName!),
          ),
          Expanded(
            flex: 2,
            child: AppText.styledBodyMedium(
                context,
                guestResponse.guestId != null
                    // ? guestResponse.guestId!
                    ? responsesController
                        .guestEmail(guestResponse.guestId!) //guest email
                    : responsesController
                        .guestName(guestResponse.inviterId!)), //inviter name
          ),
          Expanded(
              flex: 1,
              child: Center(
                child: guestResponse.isAttending == true
                    ? Icon(Icons.check)
                    : Icon(
                        Icons.close,
                        color: AppColors.error(context),
                      ),
              )),
          Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        _showDialog(
                            context, guestResponse, responsesController);
                      },
                      icon: Icon(Icons.person_outline)),
                ],
              ))
        ],
      ),
    ));
  }

  void _showDialog(BuildContext context, GuestResponse guestResponse,
      ResponsesController responsesController) {
    showDialog(
        context: context,
        builder: (context) => DetailsDialog(
            guestResponse: guestResponse,
            responsesController: responsesController));
  }

  Widget _buildHeaderRow(BuildContext context) {
    return Card(
      child: Padding(
        padding: AppPadding.horizontal(context, paddingType: Sizes.sm),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: AppText.styledBodyMedium(context, 'Name',
                  weight: FontWeight.bold),
            ),
            Expanded(
              flex: 2,
              child: AppText.styledBodyMedium(context, 'Contact',
                  weight: FontWeight.bold),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: AppText.styledBodyMedium(context, 'RSVP',
                    weight: FontWeight.bold),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: AppText.styledBodyMedium(context, 'Details',
                    weight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
