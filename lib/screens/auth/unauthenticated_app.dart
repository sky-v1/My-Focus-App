import 'package:flutter/material.dart';
import 'package:my_focus/routes/app_routes.dart';
import 'package:my_focus/screens/auth/signup_page.dart';
import 'package:my_focus/core/theme/theme.dart';

class UnauthenticatedApp extends StatelessWidget {
  const UnauthenticatedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        routes: AuthRoutes.getRoutes(),
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system, // Correct place for ThemeMode
        theme: lightTheme, // Define your light theme
        darkTheme: darkTheme, // Define your dark theme
        home: SignupScreen(
          key: ValueKey("signup"),
        ));
  }
}
