import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:trax_host_portal/controller/global_controllers/organisation_controller.dart';
import 'package:trax_host_portal/models/event.dart';

/// Controller for fetching and managing the event assigned to a host person
/// Host users can only have one event assigned to them at a time
class HostPersonEventController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Observable state
  final Rx<Event?> event = Rx<Event?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHostEvent();
  }

  /// Fetches the event assigned to the current host user
  /// 
  /// Process:
  /// 1. Get current user's UID
  /// 2. Query events collection where hostUserIds array contains this UID
  /// 3. Return the first (and only) event found
  /// 4. Initialize OrganisationController with the event's organisationId
  Future<void> fetchHostEvent() async {
    try {
      isLoading.value = true;
      error.value = '';

      // Get current user
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('No user is currently logged in');
      }

      final String uid = currentUser.uid;
      print('🔍 Fetching event for host user: $uid');

      // Query events where hostUserIds contains the current user's UID
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
          .collection('events')
          .where('hostUserIds', arrayContains: uid)
          .limit(1) // Host should only have one event
          .get();

      if (querySnapshot.docs.isEmpty) {
        print('⚠️ No event found for host user: $uid');
        event.value = null;
        error.value = 'No event assigned to you yet';
        return;
      }

      // Convert Firestore document to Event model
      final doc = querySnapshot.docs.first;
      event.value = Event.fromFirestore(doc);
      
      print('✅ Event fetched successfully: ${event.value?.name} (ID: ${event.value?.eventId})');
      
      // Initialize OrganisationController with the event's organisationId
      // This is required for AdminEventDetails to work properly
      final organisationId = event.value?.organisationId;
      if (organisationId != null && organisationId.isNotEmpty) {
        // Check if OrganisationController already exists, if not create it
        if (!Get.isRegistered<OrganisationController>()) {
          Get.put(OrganisationController(organisationId));
          print('✅ OrganisationController initialized with ID: $organisationId');
        }
      }
    } catch (e, stackTrace) {
      print('❌ Error fetching host event: $e');
      print('Stack trace: $stackTrace');
      error.value = 'Failed to load event: $e';
      event.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  /// Refreshes the event data
  Future<void> refreshEvent() async {
    await fetchHostEvent();
  }

  /// Get the event ID if available
  String? get eventId => event.value?.eventId;

  /// Check if host has an assigned event
  bool get hasEvent => event.value != null;
}
