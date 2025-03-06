import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_focus/routes/app_routes.dart';
import 'package:my_focus/screens/home/bottomNavigationBar/home_page.dart';
import 'package:my_focus/core/theme/theme.dart';
import 'package:my_focus/screens/home/bottomNavigationBar/library_page.dart';
import 'package:my_focus/screens/home/bottomNavigationBar/player_page.dart';
import 'package:my_focus/screens/home/navigationDrawer/drawer.dart';

import '../../models/user_model.dart';

class AuthenticatedApp extends ConsumerStatefulWidget {
  final UserModel user;

  const AuthenticatedApp({required this.user, super.key});

  @override
  ConsumerState<AuthenticatedApp> createState() => _AuthenticatedAppState();
}

class _AuthenticatedAppState extends ConsumerState<AuthenticatedApp> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const PlayerScreen(),
    const LibraryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: AppRoutes.getRoutes(),
        themeMode: ThemeMode.system,
        theme: lightTheme,
        darkTheme: darkTheme,
        home: Scaffold(
          drawer: AppDrawer(),
          body: IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.play_circle_outline),
                selectedIcon: Icon(Icons.play_circle),
                label: 'Player',
              ),
              NavigationDestination(
                icon: Icon(Icons.library_books_outlined),
                selectedIcon: Icon(Icons.library_books),
                label: 'Library',
              ),
            ],
          ),
        ));
  }
}
