import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> _videos = [
    {
      'title': 'Flutter Tutorial for Beginners',
      'channel': 'Flutter Dev',
      'views': '1.2M views',
      'timestamp': '2 days ago',
      'thumbnail': 'assets/thumbnail1.jpg',
    },
    {
      'title': 'Building a YouTube Clone',
      'channel': 'Tech Masters',
      'views': '845K views',
      'timestamp': '1 week ago',
      'thumbnail': 'assets/thumbnail2.jpg',
    },
    {
      'title': 'Advanced State Management',
      'channel': 'Code With Max',
      'views': '1.5M views',
      'timestamp': '3 days ago',
      'thumbnail': 'assets/thumbnail3.jpg',
    },
    {
      'title': 'UI/UX Design Patterns',
      'channel': 'Design Pro',
      'views': '632K views',
      'timestamp': '5 days ago',
      'thumbnail': 'assets/thumbnail4.jpg',
    },
  ];

  final List<Map<String, dynamic>> _channels = [
    {
      'name': 'Flutter Official',
      'subscribers': '2.4M subscribers',
      'avatar': 'assets/avatar1.jpg',
    },
    {
      'name': 'Code With Max',
      'subscribers': '1.8M subscribers',
      'avatar': 'assets/avatar2.jpg',
    },
    {
      'name': 'Design Pro',
      'subscribers': '980K subscribers',
      'avatar': 'assets/avatar3.jpg',
    },
    {
      'name': 'Tech Masters',
      'subscribers': '3.2M subscribers',
      'avatar': 'assets/avatar4.jpg',
    },
    {
      'name': 'Mobile Dev Tips',
      'subscribers': '750K subscribers',
      'avatar': 'assets/avatar5.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: false,
          pinned: true,
          expandedHeight: MediaQuery.of(context).size.height / 5,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            collapseMode: CollapseMode.pin,
            title: Text(
              "MyFocus",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimaryContainer),
            ),
            background: Container(
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
              child: Center(
                child: Image.asset(
                  "assets/images/app_logo.png",
                  height: 84,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          sliver: SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Latest Videos",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text("See all"),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 280,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              itemCount: _videos.length,
              itemBuilder: (context, index) {
                return VideoCard(video: _videos[index]);
              },
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          sliver: SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Subscribed Channels",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text("Manage"),
                ),
              ],
            ),
          ),
        ),
        SliverList.builder(
          itemCount: _channels.length,
          itemBuilder: (context, index) {
            return ChannelListItem(channel: _channels[index]);
          },
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 100),
        ),
      ],
    );
  }
}

class VideoCard extends StatelessWidget {
  final Map<String, dynamic> video;

  const VideoCard({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: 280,
      padding: EdgeInsets.symmetric(vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail with duration overlay
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    color: colorScheme.primary.withAlpha((0.3 * 255).round()),
                    child: Center(
                      child: Icon(
                        Icons.play_arrow,
                        size: 50,
                        color: Colors.white.withAlpha((0.7 * 255).round()),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha((0.7 * 255).round()),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      '12:34',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    video['channel'],
                    style: TextStyle(
                      color: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.color
                          ?.withAlpha((0.7 * 255).round()),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${video['views']} • ${video['timestamp']}',
                    style: TextStyle(
                      color: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.color
                          ?.withAlpha((0.7 * 255).round()),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChannelListItem extends StatelessWidget {
  final Map<String, dynamic> channel;

  const ChannelListItem({super.key, required this.channel});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: colorScheme.primary.withAlpha((0.2 * 255).round()),
        child: Text(
          channel['name'][0],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
      ),
      title: Text(
        channel['name'],
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        channel['subscribers'],
        style: TextStyle(
          color: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.color
              ?.withAlpha((0.7 * 255).round()),
        ),
      ),
      trailing: FilledButton(
        onPressed: () {},
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
        child: const Text('SUBSCRIBED'),
      ),
    );
  }
}
