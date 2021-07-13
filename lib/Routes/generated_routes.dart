import 'package:e_bucket/Screens/Auth_UI/sign_up.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:e_bucket/Screens/Auth_UI/log_in.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => LogInScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => LogInScreen());
      case '/signup':
        return MaterialPageRoute(builder: (_) => SignUpScreen());

      default:
        return MaterialPageRoute(builder: (_) => LogInScreen());
    }
  }
}
