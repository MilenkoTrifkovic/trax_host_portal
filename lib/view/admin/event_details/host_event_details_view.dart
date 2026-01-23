import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trax_host_portal/controller/common_controllers/event_list_controller.dart';
import 'package:trax_host_portal/controller/admin_controllers/host_controller.dart';
import 'package:trax_host_portal/helper/app_padding.dart';
import 'package:trax_host_portal/models/event.dart';
import 'package:trax_host_portal/utils/enums/sizes.dart';
import 'package:trax_host_portal/view/admin/create_event/create_edit_event_view.dart';
import 'package:trax_host_portal/view/common/event_details/widgets/cover_image.dart';
import 'package:trax_host_portal/view/common/event_details/widgets/event%20_info_section.dart';
import 'package:trax_host_portal/view/admin/event_details/widgets_old/event_setup_section.dart';
import 'package:trax_host_portal/widgets/section_devider.dart';

class HostEventDetailsView extends StatefulWidget {
  // final String eventId;
  final Event event;
  const HostEventDetailsView(
      {super.key,
      // required this.eventId,
      required this.event});

  @override
  State<HostEventDetailsView> createState() => _HostEventDetailsViewState();
}

class _HostEventDetailsViewState extends State<HostEventDetailsView> {
  HostController hostController = Get.put(HostController());
  final EventListController eventListController =
      Get.find<EventListController>();
  @override
  void initState() {
    hostController.setEvent(widget.event);
    super.initState();
    // ever(
    //   //Display error messages when they occur
    //   guestController.errorMessage,
    //   (String message) {
    //     if (message.isNotEmpty) {
    //       SnackBarUtils.showError(context, message);
    //       guestController.errorMessage.value = ''; // Reset
    //     }
    //   },
    // );
    // Future.microtask(() async {
    //   //make sure that ever is set before calling setEvent
    //   await hostController.setEvent(widget.eventId,
    //       event: widget.event); //Create Static Constructor
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (hostController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else {
        final Event? event = hostController.selectedEvent.value;
        if (event == null) {
          return const Center(child: Text('Event doesn\'t exist'));
        }
        if (hostController.isEditingEvent.value) {
          return CreateEditEventView();
        }
        return _buildEventDetails(event);
      }
    });
  }

  Widget _buildEventDetails(Event event) {
    return SingleChildScrollView(
      child: Column(
        children: [
          //Cover Image and title
          CoverImage(
            eventListController: eventListController,
            event: event,
            showAdminOptions: true,
          ),
          Padding(
            padding: AppPadding.all(context, paddingType: Sizes.lg),
            child: Column(
              children: [
                //Event info
                EventInfoSection(
                  event: event,
                ),
                //Menu Section
                SectionDivider(),
                EventSetupSection(event: event),
                SectionDivider(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
