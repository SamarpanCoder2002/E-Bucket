import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'Routes/generated_routes.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final AppRouter _appRouter = AppRouter();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: const Color.fromRGBO(4, 123, 213, 1),
  ));

  runApp(
    MaterialApp(
      title: 'Easy Market',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(4, 123, 213, 1),
        accentColor: const Color.fromRGBO(4, 123, 213, 1),
        colorScheme: ColorScheme.light(
          primary: const Color.fromRGBO(4, 123, 213, 1),
        ),
        fontFamily: 'Lora',
      ),
      onGenerateRoute: _appRouter.onGenerateRoute,
    ),
  );
}
