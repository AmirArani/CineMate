import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'route_data.dart';

// GoRouter configuration
final routerConfig = GoRouter(
  initialLocation: const RootScreenRouteData().location,
  routes: $appRoutes,
  redirect: (context, state) {
    if (state.uri.scheme == "cinemate" && state.uri.host == "login-callback") {
      debugPrint("Deep link query parameters: ${state.uri.queryParameters}");
      return "/login-callback?${state.uri.query}";
    }
    return null; // Continue as normal
  },
);
