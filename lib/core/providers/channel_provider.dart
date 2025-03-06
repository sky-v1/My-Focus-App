import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_focus/core/services/channels_service.dart';
import 'package:my_focus/models/channel_model.dart';

class ChannelState {
  final Map<String, Channel> allChannels;
  final Set<String> blockedChannelIds;
  final Set<String> visibleChannelIds;
  final bool isLoading;
  final bool isFetchingMore;
  final bool isRefreshing;
  final String? error;

  ChannelState({
    required this.allChannels,
    required this.blockedChannelIds,
    required this.visibleChannelIds,
    this.isLoading = false,
    this.isFetchingMore = false,
    this.isRefreshing = false,
    this.error,
  });

  ChannelState copyWith({
    Map<String, Channel>? allChannels,
    Set<String>? blockedChannelIds,
    Set<String>? visibleChannelIds,
    bool? isLoading,
    bool? isFetchingMore,
    bool? isRefreshing,
    String? error,
  }) {
    return ChannelState(
      allChannels: allChannels ?? this.allChannels,
      blockedChannelIds: blockedChannelIds ?? this.blockedChannelIds,
      visibleChannelIds: visibleChannelIds ?? this.visibleChannelIds,
      isLoading: isLoading ?? this.isLoading,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      error: error,
    );
  }

  List<Channel> get blockedChannels => blockedChannelIds
      .where((id) => allChannels.containsKey(id))
      .map((id) => allChannels[id]!)
      .toList();

  List<Channel> get visibleChannels => visibleChannelIds
      .where((id) => allChannels.containsKey(id))
      .map((id) => allChannels[id]!)
      .toList();
}

class ChannelNotifier extends StateNotifier<ChannelState> {
  final ChannelsLogic _channelsLogic = ChannelsLogic();

  ChannelNotifier()
      : super(ChannelState(
          allChannels: {},
          blockedChannelIds: {},
          visibleChannelIds: {},
        ));

  // Check if there are more channels to load
  bool hasMoreChannels() {
    return _channelsLogic.hasMoreChannels();
  }

  // Initial load of channels
  Future<void> loadChannels() async {
    if (state.isLoading) return;

    print("Starting to load channels...");

    state = state.copyWith(isLoading: true, error: null);

    try {
      print("Fetching subscribed channels...");
      final channels = await _channelsLogic.fetchSubscribedChannels();
      print("Fetched ${channels.length} channels.");
      _updateChannels(channels);
    } catch (e, stackTrace) {
      print("Error in loadChannels: $e\n$stackTrace");
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  // Load more channels (pagination)
  Future<void> loadMoreChannels() async {
    if (state.isFetchingMore) return;

    print("Starting to load more channels...");

    state = state.copyWith(isFetchingMore: true, error: null);

    try {
      print("Fetching more channels...");
      final moreChannels = await _channelsLogic.fetchSubscribedChannels(loadMore: true);
      print("Fetched ${moreChannels.length} more channels.");
      _updateChannels(moreChannels);
    } catch (e, stackTrace) {
      print("Error in loadMoreChannels: $e\n$stackTrace");
      state = state.copyWith(error: e.toString(), isFetchingMore: false);
    }
  }

  // Refresh all channels
  Future<void> refreshChannels() async {
    if (state.isRefreshing) return;

    print("Refreshing channels...");

    state = state.copyWith(isRefreshing: true, error: null);

    try {
      print("Resetting pagination...");
      _channelsLogic.resetPagination();

      print("Fetching refreshed channels...");
      final refreshedChannels = await _channelsLogic.fetchSubscribedChannels(forceRefresh: true);

      print("Fetched ${refreshedChannels.length} refreshed channels.");
      _updateChannels(refreshedChannels);
    } catch (e, stackTrace) {
      print("Error in refreshChannels: $e\n$stackTrace");
      state = state.copyWith(error: e.toString(), isRefreshing: false);
    }
  }

  // Update channel list and handle state changes
  void _updateChannels(List<Channel> channels) {
    print("Updating channels...");

    final Map<String, Channel> channelMap = {
      for (var channel in channels) channel.id: channel
    };

    final blockedIds = Set<String>.from(state.blockedChannelIds);
    final visibleIds = Set<String>.from(state.visibleChannelIds);

    for (var channel in channels) {
      if (!state.allChannels.containsKey(channel.id) &&
          !visibleIds.contains(channel.id)) {
        blockedIds.add(channel.id);
      }
    }

    state = state.copyWith(
      allChannels: channelMap,
      blockedChannelIds: blockedIds,
      visibleChannelIds: visibleIds,
      isLoading: false,
      isFetchingMore: false,
      isRefreshing: false,
    );

    print("Channels updated. Total: ${state.allChannels.length}");
  }

  // Block selected channels
  void blockChannels(List<String> channelIds) {
    print("Blocking channels: $channelIds");

    final blockedIds = Set<String>.from(state.blockedChannelIds);
    final visibleIds = Set<String>.from(state.visibleChannelIds);

    for (var id in channelIds) {
      blockedIds.add(id);
      visibleIds.remove(id);
    }

    state = state.copyWith(
      blockedChannelIds: blockedIds,
      visibleChannelIds: visibleIds,
    );

    print("Blocked channels updated. Total blocked: ${state.blockedChannelIds.length}");
  }

  // Unblock selected channels
  void unblockChannels(List<String> channelIds) {
    print("Unblocking channels: $channelIds");

    final blockedIds = Set<String>.from(state.blockedChannelIds);
    final visibleIds = Set<String>.from(state.visibleChannelIds);

    for (var id in channelIds) {
      blockedIds.remove(id);
      visibleIds.add(id);
    }

    state = state.copyWith(
      blockedChannelIds: blockedIds,
      visibleChannelIds: visibleIds,
    );

    print("Unblocked channels updated. Total visible: ${state.visibleChannelIds.length}");
  }
}

final channelProvider = StateNotifierProvider<ChannelNotifier, ChannelState>((ref) {
  return ChannelNotifier();
});
