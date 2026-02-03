import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:trax_host_portal/models/organisation.dart';
import 'package:trax_host_portal/services/firestore_services/firestore_services.dart';
import 'package:trax_host_portal/services/storage_services.dart';

/// ===============================
/// OrganisationController (HOST APP)
/// ===============================
/// ✅ Real-time org listener so host portal reflects admin toggle immediately.
/// ✅ Legacy-safe: resolves org doc by (docId == organisationId) OR by field.
/// ✅ Keeps logo photoUrl loaded (cached).
class OrganisationController extends GetxController {
  final FirestoreServices _firestoreServices = Get.find<FirestoreServices>();

  final organisation = Rxn<Organisation>();
  final RxBool isInitialized = false.obs;
  final RxBool isLoading = false.obs;

  /// The org identifier you pass (usually user.organisationId from event/profile)
  final String organisationId;

  /// ✅ This is what your UI should use to show/hide prices everywhere.
  final RxBool showMenuItemPrices = true.obs;

  OrganisationController(this.organisationId);

  StreamSubscription<DocumentSnapshot<Organisation>>? _orgSub;
  DocumentReference<Organisation>? _orgRef;

  String? _lastLogoPath;
  String? _lastLogoUrl;

  @override
  void onInit() {
    super.onInit();
    final id = organisationId.trim();
    if (id.isNotEmpty) {
      // ✅ realtime bind (host portal stays in sync)
      initRealtime(id);
    } else {
      isInitialized.value = true;
    }
  }

  @override
  void onClose() {
    _orgSub?.cancel();
    super.onClose();
  }

  /// Call this from outside if you want to ensure it’s bound (awaitable).
  Future<void> initRealtime(String orgId) async {
    final id = orgId.trim();
    if (id.isEmpty) {
      isInitialized.value = true;
      return;
    }

    isLoading.value = true;

    try {
      // Resolve doc ref (legacy-safe)
      _orgRef = await _resolveOrganisationRef(id);

      // 1) Load initial snapshot once (so UI has data immediately)
      final initial = await _orgRef!.get();
      if (initial.exists && initial.data() != null) {
        final org = initial.data()!;
        showMenuItemPrices.value = org.showMenuItemPrices ?? true;
        await _applyOrganisationWithLogo(org);
      }

      // 2) Start realtime listener (so admin toggle reflects instantly)
      await _orgSub?.cancel();
      _orgSub = _orgRef!.snapshots().listen((snap) async {
        if (!snap.exists || snap.data() == null) return;

        final org = snap.data()!;
        showMenuItemPrices.value = org.showMenuItemPrices ?? true;
        await _applyOrganisationWithLogo(org);

        isInitialized.value = true;
        isLoading.value = false;
      }, onError: (e) {
        print('❌ Organisation stream error: $e');
        isInitialized.value = true;
        isLoading.value = false;
      });

      isInitialized.value = true;
    } catch (e) {
      print('❌ Error initRealtime org: $e');
      isInitialized.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  /// One-time load (kept for compatibility; realtime is preferred)
  Future<void> loadOrganisation(String organisationId) async {
    final id = organisationId.trim();
    if (id.isEmpty) {
      isInitialized.value = true;
      return;
    }

    print('Loading organisation for id: $id');
    try {
      isLoading.value = true;

      final org = await _firestoreServices.getOrganisation(id);

      showMenuItemPrices.value = org.showMenuItemPrices ?? true;
      await _applyOrganisationWithLogo(org);

      isInitialized.value = true;
    } catch (e) {
      print('❌ Error loading organisation: $e');
      isInitialized.value = true; // keep app moving
    } finally {
      isLoading.value = false;
    }
  }

  Organisation? getOrganisation() => organisation.value;

  String getOrganisationName() => organisation.value?.name ?? 'Event Manager';

  String? getOrganisationPhotoUrl() => organisation.value?.photoUrl;

  void setOrganisation(Organisation org) {
    organisation.value = org;
    showMenuItemPrices.value = org.showMenuItemPrices ?? true;
  }

  Future<bool> updateOrganisation(Organisation org) async {
    try {
      final updated = await _firestoreServices.updateOrganisation(org);
      organisation.value = updated;
      showMenuItemPrices.value = updated.showMenuItemPrices ?? true;
      return true;
    } catch (e) {
      print('❌ Error updating organisation: $e');
      return false;
    }
  }

  void clearOrganisation() {
    organisation.value = null;
    _lastLogoPath = null;
    _lastLogoUrl = null;
  }

  // -----------------------------
  // Internals
  // -----------------------------

  /// ✅ Legacy-safe:
  /// - Try docId == orgId
  /// - Else query where('organisationId' == orgId)
  Future<DocumentReference<Organisation>> _resolveOrganisationRef(
    String orgId,
  ) async {
    // 1) docId == orgId
    final direct = _firestoreServices.organisationsRef.doc(orgId);
    final byDoc = await direct.get();
    if (byDoc.exists) return direct;

    // 2) legacy: organisationId field
    final q = await _firestoreServices.organisationsRef
        .where('organisationId', isEqualTo: orgId)
        .limit(1)
        .get();

    if (q.docs.isEmpty) {
      throw Exception('Organisation not found for organisationId=$orgId');
    }

    return q.docs.first.reference;
  }

  /// Loads logo URL only when path changes (cached).
  Future<void> _applyOrganisationWithLogo(Organisation org) async {
    final logoPath = (org.logo ?? '').toString().trim();

    if (logoPath.isEmpty) {
      organisation.value = org;
      _lastLogoPath = null;
      _lastLogoUrl = null;
      return;
    }

    // If same logo already loaded, reuse cached URL
    if (_lastLogoPath == logoPath && (_lastLogoUrl ?? '').isNotEmpty) {
      organisation.value = org.copyWith(photoUrl: _lastLogoUrl);
      return;
    }

    try {
      final storage = Get.find<StorageServices>();
      final url = await storage.loadImageURL(logoPath);

      _lastLogoPath = logoPath;
      _lastLogoUrl = url;

      print('✅ Loaded organisation image URL: $url');
      organisation.value = org.copyWith(photoUrl: url);
    } catch (e) {
      print('⚠️ Failed to load organisation image: $e');
      organisation.value = org; // still set org so UI works
      _lastLogoPath = logoPath;
      _lastLogoUrl = null;
    }
  }
}
