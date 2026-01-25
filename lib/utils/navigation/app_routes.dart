// Routes definition using enums for better type safety and organization
// This is the Host Portal - only host users can log in
enum AppRoute {
  // Base routes
  welcome('/welcome'),
  emailVerification('/email-verification'),

  // Host Person routes (for individual hosts)
  hostPerson('/host-person'),
  hostPersonEvents('/host-person-event'),
  hostPersonFeed('/host-person-feed'),

  // Guest / event routes
  guestEvents('/guest-events'),
  guestEventDetails('/guest-event-details/:eventId', 'eventId'),
  guestEventRespond('/guest-event-details/:eventId/respond', 'eventId'),
  guestFeed('/guest-feed'),
  guestResponse('/guest-response'),
  guestCompanions('/guest-companions'),
  guestCompanionsInfo('/guest-companions-info'),
  demographics('/demographics'),
  menuSelection('/menu-selection'),
  thankYou('/thank-you'),

  // Public guest response routes
  guestLogin('/guest-login'),
  guestResponsesPreview('/guest-responses-preview'),
  guestDemographicsView('/guest-demographics-view'),
  guestMenuSelectionView('/guest-menu-selection-view'),
  guestDemographicsEdit('/guest-demographics-edit'),
  guestMenuSelectionEdit('/guest-menu-selection-edit');

  static AppRoute? fromPath(String path) {
    final clean = path.split('?').first;

    AppRoute? best;
    int bestLen = -1;

    for (final r in AppRoute.values) {
      final base = r.path.split('/:').first; // e.g. /host-question-sets
      final matches = clean == base || clean.startsWith('$base/');
      if (matches && base.length > bestLen) {
        best = r;
        bestLen = base.length;
      }
    }
    return best;
  }

  final String path;
  final String? placeholder;

  const AppRoute(this.path, [this.placeholder]);
}
