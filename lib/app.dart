import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_focus/core/providers/auth_provider.dart';
import 'package:my_focus/screens/home/authenticated_app.dart';
import 'package:my_focus/screens/splash/splash_screen.dart';
import 'package:my_focus/screens/auth/unauthenticated_app.dart';
import 'package:my_focus/core/theme/theme.dart';

class RootApp extends ConsumerStatefulWidget {
  const RootApp({super.key});

  @override
  ConsumerState<RootApp> createState() => _RootAppState();
}

class _RootAppState extends ConsumerState<RootApp> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    if (authState.isInitializing) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: lightTheme,
        darkTheme: darkTheme,
        home: SplashScreen(key: ValueKey("splash")),
      );
    }

    return authState.isAuthenticated
        ? AuthenticatedApp(user: authState.user!)
        : UnauthenticatedApp();
  }
}
