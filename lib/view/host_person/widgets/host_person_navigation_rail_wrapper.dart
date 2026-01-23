import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:trax_host_portal/controller/auth_controller/auth_controller.dart';
import 'package:trax_host_portal/helper/screen_size.dart';
import 'package:trax_host_portal/utils/navigation/app_routes.dart';
import 'package:trax_host_portal/utils/navigation/routes.dart';
import 'package:trax_host_portal/view/admin/widgets/sidebar.dart';
import 'package:trax_host_portal/view/admin/widgets/sidebar_nav_tiles.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Navigation rail wrapper for host person (individual host users)
/// Provides navigation between events and profile with logout
class HostPersonNavigationRailWrapper extends StatefulWidget {
  final Widget child;
  
  const HostPersonNavigationRailWrapper({
    super.key,
    required this.child,
  });

  @override
  State<HostPersonNavigationRailWrapper> createState() => _HostPersonNavigationRailWrapperState();
}

class _HostPersonNavigationRailWrapperState extends State<HostPersonNavigationRailWrapper>
    with SingleTickerProviderStateMixin {
  final AuthController authController = Get.find<AuthController>();

  late final AnimationController _introCtrl;
  late final Animation<Offset> _sidebarSlide;
  late final Animation<double> _sidebarFade;
  late final Animation<double> _contentFade;

  static bool _hasPlayedIntro = false;
  bool _isExpanded = true;
  bool _initialStateSet = false;

  int _selectedIndexForLocation(String location) {
    if (location.startsWith(AppRoute.hostPersonEvents.path)) return 0;
    if (location.startsWith(AppRoute.hostPersonFeed.path)) return 1;
    return 0;
  }

  Future<void> _onTap(BuildContext context, int index) async {
    switch (index) {
      case 0:
        pushAndRemoveAllRoute(AppRoute.hostPersonEvents, context);
        return;
      case 1:
        pushAndRemoveAllRoute(AppRoute.hostPersonFeed, context);
        return;
      case 2:
        // Logout
        try {
          print('Host person: Logging out...');
          await authController.logout();
          print('Host person: Logout successful');
        } catch (e) {
          print('Host person: Logout error: $e');
        }
        
        // Ensure redirect happens after logout
        if (context.mounted) {
          print('Host person: Redirecting to welcome screen');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              pushAndRemoveAllRoute(AppRoute.welcome, context);
            }
          });
        }
        return;
    }
  }

  @override
  void initState() {
    super.initState();

    _introCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );

    _sidebarSlide = Tween<Offset>(
      begin: const Offset(-0.18, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _introCtrl, curve: Curves.easeOutCubic));

    _sidebarFade = CurvedAnimation(
      parent: _introCtrl,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    );

    _contentFade = CurvedAnimation(
      parent: _introCtrl,
      curve: const Interval(0.25, 1.0, curve: Curves.easeOut),
    );

    if (_hasPlayedIntro) {
      _introCtrl.value = 1;
    } else {
      _hasPlayedIntro = true;
      _introCtrl.forward();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialStateSet) {
      _initialStateSet = true;
      if (ScreenSize.isPhone(context)) {
        _isExpanded = false;
      }
    }
  }

  @override
  void dispose() {
    _introCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    final int selectedIndex = _selectedIndexForLocation(location);

    final bool isPhone = ScreenSize.isPhone(context);
    final bool shouldBeExpanded = isPhone ? _isExpanded : _isExpanded;

    final items = <NavItemData>[
      const NavItemData(
        label: 'Event',
        icon: Icons.event_outlined,
        selectedIcon: Icons.event,
      ),
      const NavItemData(
        label: 'Feed',
        icon: Icons.chat_bubble_outline,
        selectedIcon: Icons.chat_bubble,
      ),
      const NavItemData(
        label: 'Logout',
        icon: Icons.logout_outlined,
        selectedIcon: Icons.logout,
      ),
    ];

    // Get host name or email
    final currentUser = FirebaseAuth.instance.currentUser;
    final hostName = currentUser?.displayName ?? 
                     currentUser?.email?.split('@').first ?? 
                     'Host Portal';

    final sidebarWidget = SlideTransition(
      position: _sidebarSlide,
      child: FadeTransition(
        opacity: _sidebarFade,
        child: Sidebar(
          selectedIndex: selectedIndex,
          items: items,
          onTap: (i) => _onTap(context, i),
          isExpanded: shouldBeExpanded,
          organisationName: hostName,
          organisationPhotoUrl: currentUser?.photoURL,
          onToggleExpand: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
        ),
      ),
    );

    final contentWidget = FadeTransition(
      opacity: _contentFade,
      child: widget.child,
    );

    if (isPhone) {
      return Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(left: _isExpanded ? 0 : 72.0),
            child: contentWidget,
          ),
          if (_isExpanded)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = false;
                  });
                },
                child: Container(
                  color: Colors.black.withValues(alpha: 0.5),
                ),
              ),
            ),
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: sidebarWidget,
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sidebarWidget,
        const VerticalDivider(thickness: 1, width: 1),
        Expanded(child: contentWidget),
      ],
    );
  }
}
