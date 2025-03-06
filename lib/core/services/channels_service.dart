import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:my_focus/core/providers/auth_provider.dart';
import 'package:my_focus/core/services/auth_service.dart';
import 'dart:convert';
import 'package:my_focus/models/channel_model.dart';

class ChannelsLogic {
  static String? nextPageToken; // Store next page token for pagination
  static const int maxResults = 50;

  // Check if there are more channels to load
  bool hasMoreChannels() {
    print(
        "Checking if there are more channels to load: ${nextPageToken != null}");
    return nextPageToken != null;
  }

  // Fetch channels from API or cache
  Future<List<Channel>> fetchSubscribedChannels(
      {bool loadMore = false, bool forceRefresh = false}) async {
    print(
        "Fetching channels - loadMore: $loadMore, forceRefresh: $forceRefresh");

    final accessToken = await AuthNotifier(AuthService()).getAccessToken();
    // Open the Hive box

    final box = await Hive.openBox<Channel>('subscribedChannels');
    print("Hive box opened. Cached channels: ${box.length}");

    // Return cached channels if available and not forcing refresh or loading more
    if (!loadMore && nextPageToken == null && box.isNotEmpty && !forceRefresh) {
      print("Returning cached channels (${box.length})");
      return box.values.toList();
    }

    try {
      // Build the request URL with pagination token if loading more
      final uri = Uri.parse(
        'https://www.googleapis.com/youtube/v3/subscriptions'
        '?mine=true&part=snippet&maxResults=$maxResults'
        '${loadMore && nextPageToken != null ? '&pageToken=$nextPageToken' : ''}',
      );

      print("Requesting API: $uri");
      print("$accessToken");
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Accept': 'application/json',
        },
      );

      print("Response received with status code: ${response.statusCode}");

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to fetch channels: ${response.statusCode} - ${response.body}');
      }

      final Map<String, dynamic> data = json.decode(response.body);

      // Update pagination token
      nextPageToken = data['nextPageToken'];
      print("Updated nextPageToken: $nextPageToken");

      // Parse channel data
      final List<dynamic> items = data['items'] ?? [];
      List<Channel> newChannels =
          items.map((item) => Channel.fromJson(item)).toList();
      print("Fetched ${newChannels.length} channels from API");

      // If this is the first page (not loading more), clear the box
      if (!loadMore) {
        print("Clearing Hive box before saving new channels.");
        await box.clear();
      }

      // Save all channels to cache
      for (var channel in newChannels) {
        print("Saving channel to cache: ${channel.id}");
        await box.put(channel.id, channel);
      }

      print("Total channels in cache after update: ${box.length}");

      // Return either just the new channels or all channels depending on loadMore
      return loadMore ? box.values.toList() : newChannels;
    } catch (e, stackTrace) {
      print("Error fetching channels: $e\n$stackTrace");

      // If there's an error but we have cached data, return it
      if (box.isNotEmpty) {
        print("Returning cached channels due to error (${box.length})");
        return box.values.toList();
      }

      throw Exception('Error fetching channels: $e');
    }
  }

  // Reset pagination for fresh data load
  void resetPagination() {
    print("Resetting pagination...");
    nextPageToken = null;
  }
}
