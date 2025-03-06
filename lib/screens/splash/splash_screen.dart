import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final gradientColors = isDarkMode
        ? [
            Theme.of(context)
                .colorScheme
                .primaryContainer, // Dark mode: Softer light tone
            Theme.of(context)
                .colorScheme
                .onPrimaryFixed, // Dark mode: Deep contrast
          ]
        : [
            Theme.of(context)
                .colorScheme
                .onTertiaryContainer, // Light mode: Lighter color
            Theme.of(context)
                .colorScheme
                .primaryContainer, // Light mode: Darker shade
          ];

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: gradientColors,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/app_logo.png', width: 210, height: 210),
          ],
        ),
      ),
    );
  }
}
