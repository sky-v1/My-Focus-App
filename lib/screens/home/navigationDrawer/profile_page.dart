import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_focus/core/providers/open_yt_provider.dart';
import 'package:my_focus/core/providers/auth_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final Map<String, dynamic> _userProfile = {
    'name': 'Alex Johnson',
    'username': '@alexdev',
    'bio': 'Flutter developer & UI/UX enthusiast | Creating mobile experiences',
    'followers': '12.5K',
    'following': '843',
    'avatar': 'assets/images/default_profile.png',
    "joinedAt": "Joined 11 Jul 2020",
    "channelId": "UCwC7j0GVJm0m7NzGJUKv4rg"
  };

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: false,
            pinned: true,
            snap: false,
            expandedHeight: MediaQuery.of(context).size.height / 3.5,
            actions: [
              IconButton(
                icon: const Icon(Icons.switch_account),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  // Profile background
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          colorScheme.primaryContainer,
                          colorScheme.primary,
                        ],
                      ),
                    ),
                  ),
                  // Profile information
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 40,
                    child: Column(
                      children: [
                        // Avatar
                        CircleAvatar(
                          radius: 45,
                          backgroundColor: colorScheme.primaryContainer,
                          child: CircleAvatar(
                            radius: 42,
                            backgroundColor: colorScheme.primary,
                            child: Icon(
                              size: 50,
                              Icons.person,
                              color: colorScheme.onPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Name
                        Text(
                          _userProfile['name'],
                          style: TextStyle(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Username
                        Text(
                          _userProfile['username'],
                          style: TextStyle(
                            color: colorScheme.onPrimary,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Bio",
                            style: textTheme.headlineMedium,
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            _userProfile["bio"],
                            textAlign: TextAlign.start,
                            style: textTheme.bodyMedium,
                            maxLines: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Card(
                    child: Container(
                      margin: EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 28,
                          ),
                          const SizedBox(
                            width: 18,
                          ),
                          Text(
                            _userProfile["joinedAt"],
                            style: textTheme.bodyLarge,
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  OpenYouTubeButton(channelId: _userProfile['channelId']),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    style: ButtonStyle(
                      iconColor: WidgetStateProperty.all(colorScheme.onError),
                      backgroundColor: WidgetStateProperty.all(
                          colorScheme.error.withAlpha(200)),
                      foregroundColor:
                          WidgetStateProperty.all(colorScheme.onError),
                    ),
                    onPressed: () {
                      ref.read(authStateProvider.notifier).logout();
                    },
                    label: Text("Logout"),
                    icon: Icon(Icons.logout),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
