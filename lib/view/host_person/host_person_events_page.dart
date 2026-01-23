import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trax_host_portal/controller/host_person_controllers/host_person_event_controller.dart';
import 'package:trax_host_portal/view/admin/event_details/admin_event_details.dart';

/// Page for host person to view their assigned event
/// Host users can only have one event assigned to them
/// This page fetches the event and displays it using AdminEventDetails in read-only mode
class HostPersonEventsPage extends StatefulWidget {
  const HostPersonEventsPage({super.key});

  @override
  State<HostPersonEventsPage> createState() => _HostPersonEventsPageState();
}

class _HostPersonEventsPageState extends State<HostPersonEventsPage> {
  late final HostPersonEventController controller;

  @override
  void initState() {
    super.initState();
    // Initialize the controller
    controller = Get.put(HostPersonEventController());
  }

  @override
  void dispose() {
    // Clean up the controller when the page is disposed
    Get.delete<HostPersonEventController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Show loading state
      if (controller.isLoading.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                'Loading your event...',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        );
      }

      // Show error state
      if (controller.error.value.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 80,
                color: Colors.red[300],
              ),
              const SizedBox(height: 24),
              Text(
                'Error',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                controller.error.value,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => controller.refreshEvent(),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        );
      }

      // Show empty state (no event assigned)
      if (controller.event.value == null) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.event_busy,
                size: 80,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 24),
              Text(
                'No Event Assigned',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'You don\'t have any event assigned yet',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => controller.refreshEvent(),
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh'),
              ),
            ],
          ),
        );
      }

      // Show the event details
      final eventId = controller.eventId;
      if (eventId == null) {
        return Center(
          child: Text(
            'Invalid event data',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.red[600],
            ),
          ),
        );
      }

      // Display the event details using the existing AdminEventDetails page
      // TODO: In the future, we can add a read-only mode parameter to AdminEventDetails
      // For now, host users will have limited permissions based on Firestore rules
      return AdminEventDetails(eventId: eventId);
    });
  }
}

