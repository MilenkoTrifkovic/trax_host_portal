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

  Future<void> fetchHostEvent() async {
    try {
      isLoading.value = true;
      error.value = '';

      final User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('No user is currently logged in');
      }

      final String uid = currentUser.uid;
      print('🔍 Fetching event for host user: $uid');

      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
          .collection('events')
          .where('hostUserIds', arrayContains: uid)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print('⚠️ No event found for host user: $uid');
        event.value = null;
        error.value = 'No event assigned to you yet';
        return;
      }

      final doc = querySnapshot.docs.first;
      event.value = Event.fromFirestore(doc);

      print(
        '✅ Event fetched successfully: ${event.value?.name} (ID: ${event.value?.eventId})',
      );

      // ✅ Ensure OrganisationController is created/bound for THIS org
      final orgId = (event.value?.organisationId ?? '').trim();
      if (orgId.isNotEmpty) {
        _ensureOrganisationController(orgId);

        // Optional but useful: wait for initial org load (so event details can use org immediately)
        final orgCtrl = Get.find<OrganisationController>();
        await orgCtrl.initRealtime(orgId);

        print('✅ OrganisationController ready for orgId: $orgId');
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

  void _ensureOrganisationController(String orgId) {
    if (Get.isRegistered<OrganisationController>()) {
      final existing = Get.find<OrganisationController>();

      // If it’s already for the same org, reuse it
      if (existing.organisationId.trim() == orgId.trim()) return;

      // Different org → replace
      Get.delete<OrganisationController>(force: true);
    }

    Get.put(OrganisationController(orgId), permanent: true);
  }

  Future<void> refreshEvent() async => fetchHostEvent();

  String? get eventId => event.value?.eventId;

  bool get hasEvent => event.value != null;
}
