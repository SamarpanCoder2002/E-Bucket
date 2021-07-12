import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:e_bucket/Screens/auth_ui.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => AuthScreen());

      default:
        return MaterialPageRoute(builder: (_) => AuthScreen());
    }
  }
}
