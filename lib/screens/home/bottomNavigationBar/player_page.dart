import 'package:flutter/material.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  // Player tab selected
  double _currentPosition = 0.7; // 70% through the video
  bool _isPlaying = true;
  bool _isFullscreen = false;

  final Map<String, dynamic> _currentVideo = {
    'title': 'Complete Flutter Course - From Zero to Hero',
    'channel': 'Flutter Dev',
    'views': '1.8M views',
    'timestamp': '3 months ago',
    'likes': '125K',
    'dislikes': '1.2K',
    'description':
        'Learn Flutter from the very basics to advanced concepts in this comprehensive tutorial. We cover everything from setting up your development environment to deploying your first app.\n\nTopics covered:\n- Flutter installation and setup\n- Dart language basics\n- Building UI with widgets\n- State management\n- Navigation and routing\n- API integration\n- Using packages & plugins\n- Deployment',
  };

  final List<Map<String, dynamic>> _recommendedVideos = [
    {
      'title': 'Flutter State Management Explained',
      'channel': 'Tech Masters',
      'views': '845K views',
      'timestamp': '1 week ago',
      'thumbnail': 'assets/rec_thumbnail1.jpg',
      'duration': '12:34',
    },
    {
      'title': 'Advanced Firebase Integration',
      'channel': 'Code With Max',
      'views': '632K views',
      'timestamp': '2 weeks ago',
      'thumbnail': 'assets/rec_thumbnail2.jpg',
      'duration': '28:17',
    },
    {
      'title': 'Responsive Design in Flutter',
      'channel': 'Flutter Dev',
      'views': '328K views',
      'timestamp': '3 weeks ago',
      'thumbnail': 'assets/rec_thumbnail3.jpg',
      'duration': '16:42',
    },
    {
      'title': 'Flutter Animations Masterclass',
      'channel': 'Design Pro',
      'views': '728K views',
      'timestamp': '1 month ago',
      'thumbnail': 'assets/rec_thumbnail4.jpg',
      'duration': '32:05',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Video player section
          SliverAppBar(
            floating: false,
            pinned: true,
            expandedHeight:
                MediaQuery.of(context).size.width * 9 / 16, // 16:9 ratio
            automaticallyImplyLeading: false,
            backgroundColor: Colors.black,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                alignment: Alignment.center,
                children: [
                  // Video placeholder
                  Container(
                    color: Colors.black,
                    child: Center(
                      child: Container(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.3),
                        width: double.infinity,
                        height: double.infinity,
                        child: _isPlaying
                            ? Container()
                            : Icon(
                                Icons.play_arrow,
                                size: 80,
                                color: Colors.white.withOpacity(0.7),
                              ),
                      ),
                    ),
                  ),
                  // Video controls overlay
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                      child: Column(
                        children: [
                          // Progress bar
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 2,
                              thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 6),
                              overlayShape: const RoundSliderOverlayShape(
                                  overlayRadius: 14),
                              thumbColor: Theme.of(context).colorScheme.primary,
                              activeTrackColor:
                                  Theme.of(context).colorScheme.primary,
                              inactiveTrackColor: Colors.white.withOpacity(0.3),
                            ),
                            child: Slider(
                              value: _currentPosition,
                              onChanged: (value) {
                                setState(() {
                                  _currentPosition = value;
                                });
                              },
                            ),
                          ),
                          // Time and controls
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Time indicators
                              Text(
                                '12:25 / 17:42',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              // Control buttons
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.skip_previous,
                                        color: Colors.white),
                                    onPressed: () {},
                                    iconSize: 24,
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      _isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPlaying = !_isPlaying;
                                      });
                                    },
                                    iconSize: 32,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.skip_next,
                                        color: Colors.white),
                                    onPressed: () {},
                                    iconSize: 24,
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      _isFullscreen
                                          ? Icons.fullscreen_exit
                                          : Icons.fullscreen,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isFullscreen = !_isFullscreen;
                                      });
                                    },
                                    iconSize: 24,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Video info section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _currentVideo['title'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_currentVideo['views']} • ${_currentVideo['timestamp']}',
                    style: TextStyle(
                      color: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.color
                          ?.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildActionButton(
                          Icons.thumb_up_outlined, _currentVideo['likes']),
                      _buildActionButton(
                          Icons.thumb_down_outlined, _currentVideo['dislikes']),
                      _buildActionButton(Icons.reply_outlined, 'Share'),
                      _buildActionButton(Icons.playlist_add_outlined, 'Save'),
                      _buildActionButton(Icons.download_outlined, 'Download'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(thickness: 1),
                ],
              ),
            ),
          ),
          // Channel section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor:
                        Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    child: Text(
                      _currentVideo['channel'][0],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _currentVideo['channel'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '2.4M subscribers',
                          style: TextStyle(
                            color: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.color
                                ?.withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  FilledButton(
                    onPressed: () {},
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    child: const Text('SUBSCRIBE'),
                  ),
                ],
              ),
            ),
          ),
          // Description section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _currentVideo['description'],
                    style: const TextStyle(fontSize: 14),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('SHOW MORE'),
                  ),
                  const Divider(thickness: 1),
                ],
              ),
            ),
          ),
          // Comments section placeholder
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Comments',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '2.5K',
                        style: TextStyle(
                          color: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.color
                              ?.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                  // Comment entry field
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      radius: 16,
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.2),
                      child: Text(
                        'A',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    title: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Add a comment...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const Divider(thickness: 1),
                ],
              ),
            ),
          ),
          // Up next section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Up Next",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.autorenew),
                    label: const Text("Autoplay"),
                  ),
                ],
              ),
            ),
          ),
          // Recommended videos
          SliverList.builder(
            itemCount: _recommendedVideos.length,
            itemBuilder: (context, index) {
              return RecommendedVideoItem(video: _recommendedVideos[index]);
            },
          ),
          // Add extra space at the bottom for the navigation bar
          const SliverToBoxAdapter(
            child: SizedBox(height: 80),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color:
                Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}

class RecommendedVideoItem extends StatelessWidget {
  final Map<String, dynamic> video;

  const RecommendedVideoItem({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 160,
                  height: 90,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  child: Center(
                    child: Icon(
                      Icons.play_arrow,
                      size: 30,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 4,
                right: 4,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Text(
                    video['duration'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          // Video info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  video['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  video['channel'],
                  style: TextStyle(
                    color: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.color
                        ?.withOpacity(0.7),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${video['views']} • ${video['timestamp']}',
                  style: TextStyle(
                    color: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.color
                        ?.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Options button
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            iconSize: 20,
          ),
        ],
      ),
    );
  }
}
