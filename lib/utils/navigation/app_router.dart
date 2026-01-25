import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trax_host_portal/controller/auth_controller/auth_controller.dart';
import 'package:trax_host_portal/features/guest/guest_feed_page/view/guest_feed_page.dart';
import 'package:trax_host_portal/view/authentication/login/email_verification_view.dart';
import 'package:trax_host_portal/view/authentication/login/welcome_view.dart';
import 'package:trax_host_portal/view/host_person/host_person_events_page.dart';
import 'package:trax_host_portal/controller/host_person_controllers/host_person_event_controller.dart';
import 'package:trax_host_portal/view/host_person/widgets/host_person_navigation_rail_wrapper.dart';

/// Router setup for the Host Portal application.
/// Only host users can access this portal.

/// Routes that don't require authentication (guest routes and public routes)
const List<String> _publicRoutes = [
  '/welcome',
  '/email-verification',
  '/guest-login',
  '/guest-responses-preview',
  '/guest-demographics-view',
  '/guest-menu-selection-view',
  '/guest-demographics-edit',
  '/guest-menu-selection-edit',
  '/guest-feed',
  '/guest-events',
  '/guest-event-details',
  '/guest-response',
  '/guest-companions-info',
  '/guest-companions',
  '/demographics',
  '/menu-selection',
  '/thank-you',
];

/// Check if a path is a public/guest route
bool _isPublicRoute(String path) {
  return _publicRoutes.any((route) => path.startsWith(route));
}

GoRouter buildRouter() {
  return GoRouter(
    initialLocation: '/welcome',
    redirect: (context, state) async {
      final currentPath = state.uri.path;
      final user = FirebaseAuth.instance.currentUser;
      
      // Allow public/guest routes without auth check
      if (_isPublicRoute(currentPath)) {
        // If user is logged in as host and tries to access welcome, redirect to host events
        if (user != null && currentPath == '/welcome') {
          try {
            final authController = Get.find<AuthController>();
            if (authController.userRole.value?.name == 'host') {
              return '/host-person-event';
            }
          } catch (_) {
            // AuthController not ready yet, allow to proceed
          }
        }
        return null; // Allow access
      }
      
      // For host-person routes, check authentication
      if (currentPath.startsWith('/host-person')) {
        if (user == null) {
          // Not logged in, redirect to welcome
          return '/welcome';
        }
        
        // Check if user is host role
        try {
          final authController = Get.find<AuthController>();
          if (authController.userRole.value?.name != 'host') {
            // Non-host user, logout and redirect to welcome
            await authController.logout();
            return '/welcome';
          }
        } catch (_) {
          // AuthController not ready, redirect to welcome
          return '/welcome';
        }
        
        return null; // Allow host to proceed
      }
      
      // Default: allow navigation
      return null;
    },
    routes: <RouteBase>[
      // Root path redirects to welcome
      GoRoute(
        path: '/',
        redirect: (context, state) => '/welcome',
      ),
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeView(),
      ),
      GoRoute(
        path: '/email-verification',
        builder: (context, state) => EmailVerificationView(),
      ),
      
      // Host Person Shell Route with Navigation Rail
      ShellRoute(
        builder: (context, state, child) {
          return HostPersonNavigationRailWrapper(child: child);
        },
        routes: [
          GoRoute(
            path: '/host-person-event',
            builder: (context, state) => const HostPersonEventsPage(),
          ),
          GoRoute(
            path: '/host-person-feed',
            builder: (context, state) {
              final hostEventController = Get.find<HostPersonEventController>();
              final eventId = hostEventController.eventId ?? '';
              final eventName = hostEventController.event.value?.name;
              return GuestFeedPage(
                eventId: eventId,
                eventName: eventName,
              );
            },
          ),
        ],
      ),
     
    ],
  );
}
