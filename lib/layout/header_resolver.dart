import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Returns the header widget for a given route state.
/// 
/// This is a simplified header resolver for the Host Portal.
/// Most admin routes have been removed.
Widget getPageHeader(GoRouterState state, {BuildContext? context}) {
  // Use context-based state if available for more accurate location
  final location = context != null 
      ? GoRouterState.of(context).uri.toString()
      : state.matchedLocation;
  
  print('Header resolver - location: $location');

  // Host Portal only has host person and guest routes now
  // No custom headers needed for these routes
  return const SizedBox.shrink();
}
