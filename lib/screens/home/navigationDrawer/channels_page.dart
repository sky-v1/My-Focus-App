import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_focus/core/providers/channel_provider.dart';
import 'package:my_focus/models/channel_model.dart';

class ChannelsPage extends ConsumerStatefulWidget {
  const ChannelsPage({super.key});

  @override
  ConsumerState<ChannelsPage> createState() => _ChannelsPageState();
}

class _ChannelsPageState extends ConsumerState<ChannelsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      print("Initializing ChannelsPage: Loading channels...");
      ref.read(channelProvider.notifier).loadChannels();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _triggerHapticFeedback() async {
    try {
      await HapticFeedback.lightImpact();
      await Future.delayed(const Duration(milliseconds: 10));
      await HapticFeedback.mediumImpact();
    } catch (e) {
      debugPrint('Haptic feedback error: $e');
    }
  }

  void _toggleChannelBlock(String channelId, bool isBlocked) {
    _triggerHapticFeedback();
    if (isBlocked) {
      // If currently blocked, unblock it
      print("Unblocking channel: $channelId");
      ref.read(channelProvider.notifier).unblockChannels([channelId]);
      
    } else {
      // If currently unblocked, block it
      print("Blocking channel: $channelId");
      ref.read(channelProvider.notifier).blockChannels([channelId]);
      
    }
  }

  void _loadMoreChannels() {
    _triggerHapticFeedback();
    print("Loading more channels via button...");
    ref.read(channelProvider.notifier).loadMoreChannels();
  }

  // void _showSnackBar(String message) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(message),
  //       behavior: SnackBarBehavior.floating,
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //       margin: const EdgeInsets.all(8),
  //     ),
  //   );
  // }

  void _showInfoDialog() {
    _triggerHapticFeedback();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.info_outline,
                  color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 10),
              const Text('N O T E'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Only unblocked channels will be shown in your feed.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                Text(
                  'By default, all channels are blocked when first loaded.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  'Use the toggle switch to unblock channels you want to see content from.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Got it'),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final channelState = ref.watch(channelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Subscribed Channels"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showInfoDialog,
            tooltip: 'Help',
          ),
        ],
      ),
      body: channelState.isLoading && channelState.allChannels.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () =>
                  ref.read(channelProvider.notifier).refreshChannels(),
              child: channelState.allChannels.isEmpty
                  ? _buildEmptyState()
                  : _buildChannelGrid(channelState, colorScheme),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.subscriptions_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No channels found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Subscribe to channels to see them here',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () =>
                ref.read(channelProvider.notifier).refreshChannels(),
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
          ),
        ],
      ),
    );
  }

  Widget _buildChannelGrid(ChannelState channelState, ColorScheme colorScheme) {
    print(
        "Building channel grid. Total channels: ${channelState.allChannels.length}");

    // Convert map values to a list
    final List<Channel> channelList = channelState.allChannels.values.toList();

    // Determine if we should show the "Load More" button based on channel count
    final channelCount = channelList.length;
    final shouldShowLoadMore =
        ref.read(channelProvider.notifier).hasMoreChannels() &&
            !channelState.isFetchingMore &&
            (channelCount == 50 ||
                channelCount == 100 ||
                (channelCount > 100 && channelCount % 50 == 0));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          const SliverPadding(padding: EdgeInsets.only(top: 12.0)),
          // Channel grid
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final channel = channelList[index]; // Null check (just in case)

                final isBlocked =
                    channelState.blockedChannels.any((c) => c.id == channel.id);
                return _buildChannelCard(channel, isBlocked, colorScheme);
              },
              childCount: channelList.length,
            ),
          ),

          // Loading indicator or Load More button
          SliverToBoxAdapter(
            child: channelState.isFetchingMore
                ? Container(
                    padding: const EdgeInsets.all(16.0),
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  )
                : shouldShowLoadMore
                    ? Container(
                        padding: const EdgeInsets.all(16.0),
                        alignment: Alignment.center,
                        child: FilledButton.icon(
                          onPressed: _loadMoreChannels,
                          icon: const Icon(Icons.add),
                          label: const Text('Load More Channels'),
                        ),
                      )
                    : const SizedBox(height: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildChannelCard(
      Channel channel, bool isBlocked, ColorScheme colorScheme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outlineVariant.withAlpha((0.5 * 255).toInt()),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Channel thumbnail
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Image.network(
              channel.thumbnailUrl,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                print("Error loading thumbnail for ${channel.title}");
                return Container(
                  height: 100,
                  width: double.infinity,
                  color: colorScheme.secondaryContainer,
                  child: Icon(
                    Icons.broken_image,
                    color: colorScheme.onSecondaryContainer,
                    size: 40,
                  ),
                );
              },
            ),
          ),

          // Channel title
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              channel.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ),

          const Spacer(),

          // Switch to toggle block status
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isBlocked ? "Blocked" : "Visible",
                  style: TextStyle(
                    fontSize: 12,
                    color: isBlocked ? colorScheme.error : colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Switch(
                  value: !isBlocked, // Switch is ON when channel is NOT blocked
                  onChanged: (value) =>
                      _toggleChannelBlock(channel.id, isBlocked),
                  activeColor: colorScheme.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
