import 'package:e_bucket/Screens/Auth_UI/sign_up.dart';
import 'package:e_bucket/Screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:e_bucket/Screens/Auth_UI/log_in.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return FirebaseAuth.instance.currentUser == null
            ? MaterialPageRoute(builder: (_) => LogInScreen())
            : MaterialPageRoute(builder: (_) => HomeScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => LogInScreen());
      case '/signup':
        return MaterialPageRoute(builder: (_) => SignUpScreen());
      case '/blankScreen':
        return MaterialPageRoute(builder: (_) => HomeScreen());

      default:
        return MaterialPageRoute(builder: (_) => LogInScreen());
    }
  }
}
