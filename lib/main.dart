import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'Routes/generated_routes.dart';

void main() {
  final AppRouter _appRouter = AppRouter();

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
