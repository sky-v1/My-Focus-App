import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppDrawer extends ConsumerStatefulWidget {
  const AppDrawer({super.key});

  @override
  ConsumerState<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends ConsumerState<AppDrawer> {
  void _navigateToDestination(BuildContext context, int index) async {
    setState(() {});

    // Define navigation paths based on index
    switch (index) {
      case 0:
        Navigator.popAndPushNamed(context, "/download");
        break;
      case 1: // Channels
        Navigator.popAndPushNamed(context, "/channels");
        break;
      case 2: // Statistics
        Navigator.popAndPushNamed(context, "/statistics");
        break;
      case 3: // Settings
        Navigator.popAndPushNamed(context, "/settings");
        break;
      case 4: // About
        Navigator.popAndPushNamed(context, "/about");
        break;
      case 5: // Help
        Navigator.popAndPushNamed(context, "/help");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // final textTheme = Theme.of(context).textTheme;

    return NavigationDrawer(
      selectedIndex: null,
      onDestinationSelected: (int index) {
        _navigateToDestination(context, index);
      },
      backgroundColor: colorScheme.surface,
      elevation: 1,
      children: [
        // Header with logo and user profile
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  "assets/images/app_logo.png",
                  height: 84,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              _buildProfileButton(context),
            ],
          ),
        ),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Divider(),
        ),
        // Main navigation items
        const SizedBox(height: 8),
        NavigationDrawerDestination(
          icon: Icon(Icons.download_outlined),
          selectedIcon: Icon(Icons.download_rounded),
          label: Text("Download queue"),
        ),
        NavigationDrawerDestination(
          icon: Icon(Icons.category_outlined),
          selectedIcon: Icon(Icons.category_rounded),
          label: Text("Channels"),
        ),
        NavigationDrawerDestination(
          icon: Icon(Icons.analytics_outlined),
          selectedIcon: Icon(Icons.analytics_rounded),
          label: Text("Statistics"),
        ),
        NavigationDrawerDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: Text("Settings"),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Divider(color: colorScheme.outlineVariant),
        ),

        // Settings and help section
        const SizedBox(height: 8),
        NavigationDrawerDestination(
          icon: Icon(Icons.info_outline),
          selectedIcon: Icon(Icons.info),
          label: Text("About"),
        ),
        NavigationDrawerDestination(
          icon: Icon(Icons.help_outline),
          selectedIcon: Icon(Icons.help),
          label: Text("Help"),
        ),

        const SizedBox(height: 184),
      ],
    );
  }

  Widget _buildProfileButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.popAndPushNamed(context, "/profile");
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: colorScheme.primary,
                child: Icon(
                  Icons.person,
                  color: colorScheme.onPrimary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your Account",
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      "View profile",
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant
                            .withAlpha((0.8 * 255).toInt()),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color:
                    colorScheme.onSurfaceVariant.withAlpha((0.8 * 255).toInt()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
