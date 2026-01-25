import 'package:flutter/material.dart';

/// Admin navigation rail wrapper - simplified for host-only portal.
/// Admin shell routes have been removed, so this widget now just returns its child.
class NavigationRailWrapper extends StatelessWidget {
  final Widget child;
  
  const NavigationRailWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Admin navigation has been removed - just return the child
    return child;
  }
}
