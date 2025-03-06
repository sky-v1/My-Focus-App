import 'package:flutter/material.dart';

class ChannelInfoPage extends StatefulWidget {
  const ChannelInfoPage({super.key});

  @override
  State<ChannelInfoPage> createState() => _ChannelInfoPageState();
}

class _ChannelInfoPageState extends State<ChannelInfoPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Channel header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Channel thumbnail
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      'assets/images/app_logo.png', // Replace with your asset
                      width: 80,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Channel info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Theurgy',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text('midgart'),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.pause, size: 16),
                            const Text(' On hiatus • YouTube (EN)'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.favorite_border),
                      onPressed: () {},
                    ),
                    const Text('Add to library'),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.play_circle_outline),
                      onPressed: () {},
                    ),
                    const Text('YouTube'),
                  ],
                ),
              ],
            ),

            // Description
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Theurgy is a BL comic about a lazy demon and the idiot who accidentally summons him. Updates Thursdays.',
                style: TextStyle(fontSize: 16),
              ),
            ),

            // Tags
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                spacing: 8.0,
                children: [
                  Chip(
                    label: const Text('BL'),
                    backgroundColor: Colors.grey.shade200,
                  ),
                  Chip(
                    label: const Text('Romance'),
                    backgroundColor: Colors.grey.shade200,
                  ),
                  Chip(
                    label: const Text('Slice of life'),
                    backgroundColor: Colors.grey.shade200,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Tab bar
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Videos'),
                Tab(text: 'Live'),
                Tab(text: 'Playlists'),
              ],
            ),

            // Tab content
            SizedBox(
              height: 500, // Set a fixed height or use ConstrainedBox
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Videos Tab
                  _buildVideosList(),

                  // Live Tab
                  _buildLiveList(),

                  // Playlists Tab
                  _buildPlaylistsList(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.play_arrow),
      ),
    );
  }

  Widget _buildVideosList() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 5,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Video ${252 - index}'),
          subtitle: Text('${3 + index} days ago'),
          trailing: const Icon(Icons.download_outlined),
        );
      },
    );
  }

  Widget _buildLiveList() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 3,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Live Stream ${index + 1}'),
          subtitle: const Text('Scheduled for tomorrow'),
          trailing: const Icon(Icons.notifications_outlined),
        );
      },
    );
  }

  Widget _buildPlaylistsList() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 4,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Playlist ${index + 1}'),
          subtitle: Text('${index + 5} videos'),
          trailing: const Icon(Icons.playlist_play),
        );
      },
    );
  }
}
