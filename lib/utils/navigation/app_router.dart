import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trax_host_portal/controller/auth_controller/auth_controller.dart';
import 'package:trax_host_portal/controller/common_controllers/event_controller.dart';
import 'package:trax_host_portal/controller/common_controllers/event_list_controller.dart';
import 'package:trax_host_portal/controller/global_controllers/events_controller.dart';
import 'package:trax_host_portal/controller/global_controllers/guest_controllers/guest_session_controller.dart';
import 'package:trax_host_portal/controller/global_controllers/organisation_controller.dart';
import 'package:trax_host_portal/controller/global_controllers/users_and_roles_controller.dart';
import 'package:trax_host_portal/controller/global_controllers/venues_controller.dart';
import 'package:trax_host_portal/controller/menus_list_controller.dart';
import 'package:trax_host_portal/controller/menus_screen_controller.dart';
import 'package:trax_host_portal/features/common/calendar_page/view/calendar_page.dart';
import 'package:trax_host_portal/features/guest/rsvp_response/controller/rsvp_response_controller.dart';
import 'package:trax_host_portal/features/guest/rsvp_response/view/compaignons_info_page.dart';
import 'package:trax_host_portal/features/guest/rsvp_response/view/guest_count_page.dart';
import 'package:trax_host_portal/features/guest/rsvp_response/view/guest_thank_you_page.dart';
import 'package:trax_host_portal/features/settings/view/settings_page.dart';
import 'package:trax_host_portal/helper/fetch_event.dart';
import 'package:trax_host_portal/layout/guest_layout/controllers/guest_layout_controller.dart';
import 'package:trax_host_portal/layout/header_resolver.dart';
import 'package:trax_host_portal/models/event.dart';
import 'package:trax_host_portal/utils/navigation/app_routes.dart';
import 'package:trax_host_portal/utils/navigation/custom_error_page.dart';
import 'package:trax_host_portal/utils/navigation/routes.dart';
import 'package:trax_host_portal/view/admin/event_details/admin_event_details.dart';
import 'package:trax_host_portal/view/admin/event_details/demographic_response_page.dart';
import 'package:trax_host_portal/view/admin/event_details/menu_response_page.dart';
import 'package:trax_host_portal/view/admin/event_details/thank_you_page.dart';
import 'package:trax_host_portal/features/guest/rsvp_response/view/rsvp_response_page.dart';
import 'package:trax_host_portal/view/admin/questions/host_questions_rules_screen.dart';
import 'package:trax_host_portal/view/admin/questions/host_questions_sets_screen.dart';
import 'package:trax_host_portal/view/admin/venues_and_menus/menus_details_view.dart';
import 'package:trax_host_portal/view/admin/venues_and_menus/menus_view.dart';
import 'package:trax_host_portal/features/admin/admin_user_management/view/admin_user_list_page.dart';
import 'package:trax_host_portal/view/authentication/login/email_verification_view.dart';
import 'package:trax_host_portal/view/guest/guest_event_details.dart';
import 'package:trax_host_portal/view/guest/respond/respond_screen.dart';
import 'package:trax_host_portal/view/admin/create_event/create_edit_event_view.dart';
import 'package:trax_host_portal/view/admin/event_details/widgets_old/guests_section/set_guests._view.dart';
import 'package:trax_host_portal/view/admin/event_details/widgets_old/menu_section/set_menus_view.dart';
import 'package:trax_host_portal/view/admin/event_details/widgets_old/questions_section/set_questions_view.dart';
import 'package:trax_host_portal/view/admin/venues_and_menus/venues_view.dart';
import 'package:trax_host_portal/view/admin/questions/host_questions_screen.dart';
import 'package:trax_host_portal/view/common/event_list_screen.dart';
import 'package:trax_host_portal/view/admin/event_details/widgets_old/responses_section.dart/responses_view.dart';
import 'package:trax_host_portal/view/admin/organisation_info_popup/organisation_info_popup_view.dart';
import 'package:trax_host_portal/view/admin/widgets/navigation_rail_wrapper.dart';
import 'package:trax_host_portal/view/authentication/login/welcome_view.dart';
import 'package:trax_host_portal/widgets/content_wrapper.dart';
import 'package:trax_host_portal/widgets/event_loader.dart';
import 'package:trax_host_portal/layout/guest_layout/guest_page_wrapper.dart';
import 'package:trax_host_portal/view/admin/event_details/event_demographic_analyzer_page.dart';
import 'package:trax_host_portal/view/admin/event_details/event_menu_analyzer_page.dart';
import 'package:trax_host_portal/features/admin/admin_guest_side_preview/view/guest_side_preview_page.dart';
import 'package:trax_host_portal/features/guest/guest_login/view/guest_login_page.dart';
import 'package:trax_host_portal/features/guest/guest_responses_preview_edit/view/guest_responses_preview_page.dart';
import 'package:trax_host_portal/features/guest/guest_responses_preview_edit/view/guest_demographics_view_page.dart';
import 'package:trax_host_portal/features/guest/guest_responses_preview_edit/view/guest_menu_selection_view_page.dart';
import 'package:trax_host_portal/features/guest/guest_responses_preview_edit/view/guest_demographics_edit_page.dart';
import 'package:trax_host_portal/features/guest/guest_responses_preview_edit/view/guest_menu_selection_edit_page.dart';
import 'package:trax_host_portal/features/guest/guest_feed_page/view/guest_feed_page.dart';
import 'package:trax_host_portal/view/guest/widgets/guest_navigation_rail_wrapper.dart';
import 'package:trax_host_portal/view/host_person/host_person_events_page.dart';
import 'package:trax_host_portal/controller/host_person_controllers/host_person_event_controller.dart';
import 'package:trax_host_portal/view/host_person/widgets/host_person_navigation_rail_wrapper.dart';

/// Router setup for the Traxx application.
/// Currently implementing basic navigation structure with go_router.
///

/// Key for the host section's nested navigation
final GlobalKey<NavigatorState> hostNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> hostPersonNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> guestNavigationKey =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> guestAuthNavigatorKey =
    GlobalKey<NavigatorState>();

///
/// Structure:
/// - Public routes (welcome, about, contact)
/// - Host section with nested navigation
GoRouter buildRouter() {
  final eventController = Get.find<EventController>();
  final authController = Get.find<AuthController>();
  return GoRouter(
    debugLogDiagnostics: true,
    initialLocation: AppRoute.welcome.path,
    routes: <RouteBase>[
      GoRoute(
        path: AppRoute.welcome.path,
        builder: (context, state) {
          final User? currentUser = FirebaseAuth.instance.currentUser;

          if (currentUser != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              // Load user profile to check role
              await authController.loadUserProfile();
              
              final userRole = authController.userRole.value;
              
              if (userRole?.name == 'host') {
                print('Router: User is a host, redirecting to host person portal');
                if (context.mounted) {
                  pushAndRemoveAllRoute(AppRoute.hostPersonEvents, context);
                }
              } else if (authController.companyInfoExists) {
                print('Router: User is admin with org, redirecting to admin portal');
                if (context.mounted) {
                  pushAndRemoveAllRoute(AppRoute.hostEvents, context);
                }
              } else {
                print('Router: User is admin without org, redirecting to org form');
                if (context.mounted) {
                  pushAndRemoveAllRoute(AppRoute.hostOrganisationInfoForm, context);
                }
              }
            });
          }

          return const WelcomeView();
        },
      ),

      GoRoute(
        redirect: (context, state) {
          if (authController.isAuthenticatedAndVerified) {
            // Check user role to determine where to redirect
            final userRole = authController.userRole.value;
            
            if (userRole?.name == 'host') {
              print('Email verification: User is a host, redirecting to host person portal');
              return AppRoute.hostPersonEvents.path;
            } else if (authController.companyInfoExists) {
              print('Email verification: User is admin with org, redirecting to admin portal');
              return AppRoute.hostEvents.path;
            } else {
              print('Email verification: User is admin without org, redirecting to org form');
              return AppRoute.hostOrganisationInfoForm.path;
            }
          }
          return null;
        },
        path: AppRoute.emailVerification.path,
        builder: (context, state) => EmailVerificationView(),
      ),
      GoRoute(
        redirect: (context, state) {
          if (!authController.isAuthenticated) {
            return AppRoute.welcome.path;
          }
          if (!authController.isAuthenticatedAndVerified) {
            // Must verify email first
            return AppRoute.emailVerification.path;
          }
          
          // ✅ Check if user is a host - they should go to host person portal, not org form
          final userRole = authController.userRole.value;
          if (userRole?.name == 'host') {
            print('Organisation form: User is a host, redirecting to host person portal');
            return AppRoute.hostPersonEvents.path;
          }
          
          if (authController.companyInfoExists) {
            // Org already exists → go straight to host events
            return AppRoute.hostEvents.path;
          }
          // Otherwise show the organisation form
          return null;
        },
        path: AppRoute.hostOrganisationInfoForm.path,
        builder: (context, state) => const OrganisationInfoPopupView(),
      ),

      GoRoute(
        path: AppRoute.thankYou.path,
        builder: (context, state) {
          final invId =
              (state.uri.queryParameters['invitationId'] ?? '').trim();
          final token = (state.uri.queryParameters['token'] ?? '').trim();
          return GuestThankYouPage(invitationId: invId, token: token);
        },
      ),

      // GUEST AUTHENTICATED SHELL ROUTE
      // Handles guest authentication and session management
      // All guest routes that require authentication go here
      ShellRoute(
        navigatorKey: guestAuthNavigatorKey,
        redirect: (context, state) {
          final guestSession = Get.find<GuestSessionController>();

          // If on login page and already authenticated, redirect to responses preview
          if (state.matchedLocation == AppRoute.guestLogin.path) {
            if (guestSession.isAuthenticated) {
              print(
                  '✅ Guest already authenticated, redirecting to responses preview');
              return AppRoute.guestResponsesPreview.path;
            }
            // Not authenticated, allow access to login page
            return null;
          }

          // For all other guest routes, check if authenticated
          if (!guestSession.isAuthenticated) {
            print('🔒 Guest not authenticated, redirecting to login');
            return AppRoute.guestLogin.path;
          }

          print('✅ Guest authenticated, allowing access');
          return null; // Allow access to protected route
        },
        builder: (context, state, child) {
          // If on login page, don't show navigation rail
          if (state.matchedLocation == AppRoute.guestLogin.path) {
            print('ONLY CHILD RETURNED');
            return child;
          }

          // For feed page, don't wrap in ContentWrapper as it has its own Scaffold
          if (state.matchedLocation == AppRoute.guestFeed.path) {
            return GuestNavigationRailWrapper(
              child: child,
            );
          }

          // For authenticated routes, show navigation rail and content wrapper
          return GuestNavigationRailWrapper(
            child: ContentWrapper(
              child: child,
            ),
          );
        },
        routes: [
          // Public guest login route
          GoRoute(
            path: AppRoute.guestLogin.path,
            builder: (context, state) => const GuestLoginPage(),
          ),

          // Guest responses preview page (authenticated)
          GoRoute(
            path: AppRoute.guestResponsesPreview.path,
            builder: (context, state) => const GuestResponsesPreviewPage(),
          ),

          // Guest demographics view page (authenticated)
          GoRoute(
            path: AppRoute.guestDemographicsView.path,
            builder: (context, state) => const GuestDemographicsViewPage(),
          ),

          // Guest menu selection view page (authenticated)
          GoRoute(
            path: AppRoute.guestMenuSelectionView.path,
            builder: (context, state) => const GuestMenuSelectionViewPage(),
          ),

          // Guest demographics edit page (authenticated)
          GoRoute(
            path: AppRoute.guestDemographicsEdit.path,
            builder: (context, state) => const GuestDemographicsEditPage(),
          ),

          // Guest menu selection edit page (authenticated)
          GoRoute(
            path: AppRoute.guestMenuSelectionEdit.path,
            builder: (context, state) => const GuestMenuSelectionEditPage(),
          ),

          // Guest feed page (authenticated)
          GoRoute(
            path: AppRoute.guestFeed.path,
            builder: (context, state) {
              final guestSession = Get.find<GuestSessionController>();
              final eventId = guestSession.event.value?.eventId ?? '';
              final eventName = guestSession.event.value?.name;

              return GuestFeedPage(
                eventId: eventId,
                eventName: eventName,
              );
            },
          ),

          // TODO: Add more authenticated guest routes here
          // Example:
          // GoRoute(
          //   path: AppRoute.guestDashboard.path,
          //   builder: (context, state) => const GuestDashboardPage(),
          // ),
        ],
      ),

      // GUEST RESPONSE SHELL ROUTE
      // Public routes for guests responding to invitations (RSVP → Demographics → Menu → Thank You)
      ShellRoute(
        builder: (context, state, child) {
          final invitationId = state.uri.queryParameters['invitationId'] ?? '';
          final token = state.uri.queryParameters['token'] ?? '';

          final rsvpCtrl = Get.put(RsvpResponseController(), tag: invitationId);
          rsvpCtrl.invitationId = invitationId;
          rsvpCtrl.token = token;

          // Always ensure load at least once
          if (rsvpCtrl.invitationStatus.value == null &&
              !rsvpCtrl.isLoading.value) {
            rsvpCtrl.checkExistingResponse();
          }

          // ✅ CREATE GuestLayoutController HERE (not later)
          final guestLayout =
              Get.put(GuestLayoutController(), tag: invitationId);

          // start loading event immediately
          guestLayout.loadEventCoverImageFromInvitation(invitationId);

          return GuestPageWrapper(
            invitationId: invitationId,
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: AppRoute.guestResponse.path,
            builder: (context, state) {
              final invitationId =
                  state.uri.queryParameters['invitationId'] ?? '';
              final token = state.uri.queryParameters['token'] ?? '';
              final eventName = state.uri.queryParameters['eventName'];

              final forceDetails =
                  (state.uri.queryParameters['view'] ?? '') == 'details';

              return RsvpResponsePage(
                invitationId: invitationId,
                token: token,
                eventName: eventName,
                forceDetails: forceDetails, // ✅ NEW
              );
            },
          ),

          GoRoute(
            path: AppRoute.guestCompanionsInfo.path,
            builder: (context, state) {
              final invitationId =
                  state.uri.queryParameters['invitationId'] ?? '';
              final token = state.uri.queryParameters['token'] ?? '';
              final eventName = state.uri.queryParameters['eventName'];
              return CompaignonsInfoPage(
                invitationId: invitationId,
                token: token,
                eventName: eventName,
              );
            },
          ),
          GoRoute(
            path: AppRoute.guestCompanions.path,
            builder: (context, state) {
              final invitationId =
                  state.uri.queryParameters['invitationId'] ?? '';
              final token = state.uri.queryParameters['token'] ?? '';
              final eventName = state.uri.queryParameters['eventName'];
              return GuestCountPage(
                invitationId: invitationId,
                token: token,
                eventName: eventName,
              );
            },
          ),
          GoRoute(
            path: AppRoute.demographics.path,
            builder: (context, state) {
              final invitationId =
                  state.uri.queryParameters['invitationId'] ?? '';
              final token = state.uri.queryParameters['token'] ?? '';

              // Parse companion index if provided
              final companionIndexStr =
                  state.uri.queryParameters['companionIndex'];
              final int? companionIndex = companionIndexStr != null
                  ? int.tryParse(companionIndexStr)
                  : null;

              // Get companion name if provided
              final companionName = state.uri.queryParameters['companionName'];

              return DemographicResponsePage(
                invitationId: invitationId,
                token: token,
                embedded: false,
                showInvitationInput: false,
                companionIndex: companionIndex,
                companionName: companionName,
              );
            },
          ),
          GoRoute(
            path: AppRoute.menuSelection.path,
            builder: (context, state) {
              final invitationId =
                  state.uri.queryParameters['invitationId'] ?? '';

              // Parse companion index if provided
              final companionIndexStr =
                  state.uri.queryParameters['companionIndex'];
              final int? companionIndex = companionIndexStr != null
                  ? int.tryParse(companionIndexStr)
                  : null;

              // Get companion name if provided
              final companionName = state.uri.queryParameters['companionName'];

              return GuestMenuSelectionPage(
                invitationId: invitationId,
                companionIndex: companionIndex,
                companionName: companionName,
              );
            },
          ),
          // GoRoute(
          //   path: AppRoute.menuSelection.path,
          //   builder: (context, state) {
          //     final invitationId = state.uri.queryParameters['invitationId'] ?? '';
          //     return GuestMenuSelectionPage(invitationId: invitationId);
          //   },
          // ),
          GoRoute(
            path: AppRoute.thankYou.path,
            redirect: (context, state) {
              final invitationId =
                  (state.uri.queryParameters['invitationId'] ?? '').trim();
              final token = (state.uri.queryParameters['token'] ?? '').trim();
              final eventName = state.uri.queryParameters['eventName'];

              // If invitationId is missing, just go to guest-response base route
              if (invitationId.isEmpty) {
                return AppRoute.guestResponse.path;
              }

              return Uri(
                path: AppRoute.guestResponse.path,
                queryParameters: {
                  'invitationId': invitationId,
                  if (token.isNotEmpty) 'token': token,
                  if (eventName != null && eventName.trim().isNotEmpty)
                    'eventName': eventName.trim(),
                },
              ).toString();
            },
          ),
        ],
      ),

      // HOST PERSON SHELL ROUTE
      // For individual host users (not admins)
      ShellRoute(
        navigatorKey: hostPersonNavigatorKey,
        redirect: (context, state) {
          if (!authController.isAuthenticated) {
            print('Host person: Not authenticated, redirecting to welcome');
            return AppRoute.welcome.path;
          }

          if (!authController.isAuthenticatedAndVerified) {
            print('Host person: Not verified, redirecting to email verification');
            return AppRoute.emailVerification.path;
          }

          // Check if user has host role
          final userRole = authController.userRole.value;
          if (userRole?.name != 'host') {
            print('Host person: User is not a host (role: ${userRole?.name}), redirecting to welcome');
            return AppRoute.welcome.path;
          }

          print('Host person: All checks passed, allowing access');
          return null;
        },
        builder: (context, state, child) {
          // Initialize required controllers for host person
          Get.put(VenuesController());
          Get.put(MenusListController());
          Get.put(MenusScreenController());
          
          return Obx(() {
            // Check authentication state reactively
            if (!authController.isAuthenticated) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) {
                  pushAndRemoveAllRoute(AppRoute.welcome, context);
                }
              });
              return const Center(child: CircularProgressIndicator());
            }

            // Check if user data is still loading
            if (authController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            // Additional role check in builder
            final userRole = authController.userRole.value;
            if (userRole?.name != 'host') {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) {
                  pushAndRemoveAllRoute(AppRoute.welcome, context);
                }
              });
              return const Center(child: CircularProgressIndicator());
            }

            // For feed page, don't include header or ContentWrapper as it has its own layout
            if (state.matchedLocation == AppRoute.hostPersonFeed.path) {
              return HostPersonNavigationRailWrapper(
                child: child,
              );
            }

            // For other pages, include header and ContentWrapper
            return HostPersonNavigationRailWrapper(
              child: ContentWrapper(
                contentColor: const Color.fromARGB(255, 247, 247, 247),
                header: getPageHeader(state, context: context),
                child: child,
              ),
            );
          });
        },
        routes: [
          GoRoute(
            path: AppRoute.hostPersonEvents.path,
            builder: (context, state) => const HostPersonEventsPage(),
          ),
          GoRoute(
            path: AppRoute.hostPersonFeed.path,
            builder: (context, state) {
              // Get event ID from the host person event controller
              // The controller should already be initialized when entering host person shell
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

      //HOST SHELL ROUTE
      ShellRoute(
        redirect: (context, state) {
          if (!authController.isAuthenticated) {
            print('Admin portal: Redirecting to welcome');
            return AppRoute.welcome.path;
          }

          if (!authController.isAuthenticatedAndVerified) {
            print('Admin portal: Redirecting to email verification');
            return AppRoute.emailVerification.path;
          }

          // ✅ Check if user is a host - they should go to host person portal, not admin portal
          final userRole = authController.userRole.value;
          if (userRole?.name == 'host') {
            print('Admin portal: User is a host, redirecting to host person portal');
            return AppRoute.hostPersonEvents.path;
          }

          if (!authController.companyInfoExists) {
            print('Admin portal: Redirecting to organisation info form');
            return AppRoute.hostOrganisationInfoForm.path;
          }
          print('Admin portal: Redirecting in host shell route passed');
          return null;
        },
        navigatorKey: hostNavigatorKey,
        builder: (context, state, child) {
          // Check if user is authenticated
          final User? currentUser = FirebaseAuth.instance.currentUser;
          // if (currentUser == null || !currentUser.emailVerified) {
          if (currentUser == null) {
            // If user is not authenticated, redirect to welcome
            WidgetsBinding.instance.addPostFrameCallback((_) {
              pushAndRemoveAllRoute(AppRoute.welcome, context);
              // pushAndRemoveAllRoute(AppRoute.emailVerification, context);
            });
            return Center(child: CircularProgressIndicator());
          }

          final eventListController = Get.find<EventListController>();
          final authController = Get.find<AuthController>();
          Get.put(VenuesController());
          Get.put(MenusListController());
          Get.put(MenusScreenController());
          Get.put(EventsController());
          Get.put(OrganisationController(authController.organisationId!));
          Get.put(UsersAndRolesController());

          return Obx(() {
            try {
              if (eventListController.isLoading.value ||
                  authController.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }
              
              // ✅ Additional check: If user is a host, redirect them
              final userRole = authController.userRole.value;
              if (userRole?.name == 'host') {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (context.mounted) {
                    print('Admin portal builder: User is a host, redirecting to host person portal');
                    pushAndRemoveAllRoute(AppRoute.hostPersonEvents, context);
                  }
                });
                return Center(child: CircularProgressIndicator());
              }
              
              final location = state.matchedLocation;

              // Treat these paths as Google Forms–style question pages
              final isQuestionsPage = location
                      .startsWith(AppRoute.hostQuestionSets.path) ||
                  location.startsWith(AppRoute.hostQuestions.path) ||
                  location.startsWith(AppRoute.hostQuestionSetQuestions.path);

              const Color gfBackground = Color(0xFFF4F0FB);

              return NavigationRailWrapper(
                child: ContentWrapper(
                  contentColor: isQuestionsPage
                      ? gfBackground // Color(0xFFF4F0FB)
                      : const Color.fromARGB(255, 247, 247, 247),
                  header: getPageHeader(state, context: context),
                  child: child,
                ),
              );
            } catch (e) {
              print('Exception in host shell route builder: $e');
              return Center(child: Text('Error: $e'));
              // Error Handling or redirection
            }
          });
        },
        routes: [
          GoRoute(
            path: AppRoute.hostEvents.path,
            builder: (context, state) => EventListScreen(),
          ),
          GoRoute(
            path: AppRoute.calendarView.path,
            builder: (context, state) => const CalendarPage(),
          ),
          GoRoute(
            path: AppRoute.hostMenus.path,
            builder: (context, state) => MenusView(),
          ),
          GoRoute(
            path: AppRoute.hostMenuDetails.path,
            builder: (context, state) {
              final menuId =
                  state.pathParameters[AppRoute.hostMenuDetails.placeholder]!;
              return MenuSetDetailsView(menuId: menuId);
            },
          ),
          GoRoute(
            path: AppRoute.hostVenues.path,
            builder: (context, state) => const VenuesView(),
          ),
          GoRoute(
            path: AppRoute.hostVenueDetails.path,
            builder: (context, state) {
              final venueId =
                  state.pathParameters[AppRoute.hostVenueDetails.placeholder]!;
              return VenuesView();
            },
          ),
          GoRoute(
            path: AppRoute.hostRoleSelection.path,
            builder: (context, state) {
              return AdminUserListPage();
            },
          ),
          GoRoute(
            path: AppRoute.hostQuestionSets.path,
            builder: (context, state) => const QuestionSetsScreen(),
          ),
          GoRoute(
            path: AppRoute.hostQuestions.path,
            builder: (context, state) {
              final setId = state.uri.queryParameters['setId'] ?? '';
              final setTitle = state.uri.queryParameters['setTitle'] ?? '';
              final setDescription =
                  state.uri.queryParameters['setDescription'] ?? '';

              if (setId.isEmpty) {
                return const QuestionSetsScreen();
              }

              return HostQuestionsScreen(
                questionSetId: setId,
              );
            },
          ),
          GoRoute(
            path: AppRoute.hostQuestionRules.path,
            builder: (context, state) => const QuestionRulesScreen(),
          ),

          GoRoute(
            path: AppRoute.hostQuestionSetQuestions.path,
            builder: (context, state) {
              final setId = state.pathParameters[
                  AppRoute.hostQuestionSetQuestions.placeholder]!;
              final setTitle = state.uri.queryParameters['setTitle'] ?? '';
              final setDescription =
                  state.uri.queryParameters['setDescription'] ?? '';
              return HostQuestionsScreen(
                questionSetId: setId,
              );
            },
          ),

          GoRoute(
            path: AppRoute.hostCreateEvent.path,
            builder: (context, state) => CreateEditEventView(),
          ),
          GoRoute(
            path: AppRoute.eventDetails.path,
            builder: (context, state) {
              final eventId =
                  state.pathParameters[AppRoute.eventDetails.placeholder]!;
              return AdminEventDetails(
                eventId: eventId,
              );
            },
          ),
          GoRoute(
            path: AppRoute.hostSettings.path,
            builder: (context, state) => SettingsPage(),
          ),
          GoRoute(
            path: AppRoute.eventQuestions.path,
            builder: (context, state) => SetQuestionsView(),
          ),
          GoRoute(
            path: AppRoute.eventMenus.path,
            builder: (context, state) {
              final Event? selectedEvent = eventController.selectedEvent.value;
              final eventId =
                  state.pathParameters[AppRoute.eventDetails.placeholder]!;
              if (selectedEvent != null) {
                return SetMenusView();
              }

              return FutureBuilder<Event>(
                future: EventFetcher.fetchEvent(eventId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  eventController.setSelectedEvent(snapshot.data!);

                  return SetMenusView();
                },
              );
            },
          ),
          GoRoute(
            path: AppRoute.eventDemographicAnalyzer.path,
            builder: (context, state) {
              final eventId = state.pathParameters[
                  AppRoute.eventDemographicAnalyzer.placeholder]!;
              return EventDemographicAnalyzerPage(eventId: eventId);
            },
          ),
          GoRoute(
            path: AppRoute.eventMenuAnalyzer.path,
            builder: (context, state) {
              final eventId =
                  state.pathParameters[AppRoute.eventMenuAnalyzer.placeholder]!;
              return EventMenuAnalyzerPage(eventId: eventId);
            },
          ),
          GoRoute(
            path: AppRoute.guestSidePreview.path,
            builder: (context, state) {
              final eventId =
                  state.pathParameters[AppRoute.guestSidePreview.placeholder]!;
              return GuestSidePreviewPage(eventId: eventId);
            },
          ),

          GoRoute(
            path: AppRoute.eventGuests.path,
            builder: (context, state) => SetGuestsView(),
          ),
          GoRoute(
            path: AppRoute.eventResponses.path,
            builder: (context, state) {
              String eventId =
                  state.pathParameters[AppRoute.eventResponses.placeholder]!;
              return EventLoader(
                eventController: eventController,
                eventId: eventId,
                builder: (context, event) => ResponsesView(),
              );
            },
          ),
          // GoRoute(
          //   path: AppRoute.hostDemographics.path,
          //   builder: (context, state) {
          //     final invitationId =
          //         state.uri.queryParameters['invitationId'] ?? '';
          //     return DemographicResponsePage(
          //       invitationId: invitationId,
          //       showInvitationInput: true,
          //       embedded: true, // ✅ NEW
          //     );
          //   },
          // ),
        ],
      ),
      // Guest Shell Route
      ShellRoute(
        navigatorKey: guestNavigationKey,
        builder: (context, state, child) {
          final eventListController = Get.find<EventListController>();
          final authController = Get.find<AuthController>();
          return Obx(() {
            try {
              if (eventListController.isLoading.value ||
                  authController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final location = state.matchedLocation;

              // Treat these paths as Google Forms–style question pages
              final isQuestionsPage = location
                      .startsWith(AppRoute.hostQuestionSets.path) ||
                  location.startsWith(AppRoute.hostQuestions.path) ||
                  location.startsWith(AppRoute.hostQuestionSetQuestions.path);

              const Color gfBackground = Color(0xFFF4F0FB);

              if (isQuestionsPage) {
                // ✅ QUESTION PAGES:
                // Header is drawn OUTSIDE ContentWrapper so it spans full width.
                return NavigationRailWrapper(
                  child: Column(
                    children: [
                      // full-width header
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 40,
                          right: 40,
                          top: 24,
                          bottom: 8,
                        ),
                        child: getPageHeader(state, context: context),
                      ),
                      // content area with lavender background + limited-width body
                      Expanded(
                        child: ContentWrapper(
                          contentColor: gfBackground,
                          // no header here – body only
                          child: child,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                // ✅ ALL OTHER PAGES – behave exactly as before
                return NavigationRailWrapper(
                  child: ContentWrapper(
                    contentColor: const Color.fromARGB(255, 247, 247, 247),
                    header: getPageHeader(state, context: context),
                    child: child,
                  ),
                );
              }
            } catch (e) {
              return Container(); //Temporary
            }
          });
        },
        routes: [
          GoRoute(
            path: AppRoute.guestEvents.path,
            builder: (context, state) => EventListScreen(),
          ),
          GoRoute(
            path: AppRoute.guestEventDetails.path,
            builder: (context, state) {
              final Event? event = eventController.selectedEvent.value;
              if (event != null) {
                return GuestEventDetails();
              }

              final eventId =
                  state.pathParameters[AppRoute.guestEventDetails.placeholder]!;
              return FutureBuilder<Event>(
                future: EventFetcher.fetchEvent(eventId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  eventController.setSelectedEvent(snapshot.data!);

                  return GuestEventDetails();
                },
              );
            },
          ),
          GoRoute(
            path: AppRoute.guestEventRespond.path,
            builder: (context, state) {
              final eventId =
                  state.pathParameters[AppRoute.eventDetails.placeholder]!;
              final Event? selectedEvent = eventController.selectedEvent.value;
              if (selectedEvent != null) {
                return RespondScreen(event: selectedEvent);
              }
              // final Event? event;
              // if (state.extra != null && state.extra is Event) {
              //   event = state.extra as Event;
              // } else {
              //   event = null;
              // }
              // final eventId =
              //     state.pathParameters[AppRoute.guestEventRespond.placeholder]!;
              //     Event event = EventFetcher()
              // return RespondScreen(eventId: eventId);
              return FutureBuilder<Event>(
                future: EventFetcher.fetchEvent(eventId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  return RespondScreen(event: snapshot.data!);
                },
              );
            },
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => CustomErrorPage(),
  );
}
