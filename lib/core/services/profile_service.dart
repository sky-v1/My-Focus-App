import 'dart:async';
import 'dart:convert';
import 'package:my_focus/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfileService {
  // API Base URL for YouTube Data API
  static const String _youtubeApiBase = 'https://www.googleapis.com/youtube/v3';
  static const String _cacheKey = 'user_profile_cache';

  final String apiKey;

  ProfileService({required this.apiKey});

  // Fetch profile data from YouTube API
  Future<UserModel> getUserProfile(String accessToken) async {
    try {
      // First, check local cache for faster response
      final cachedData = await _getCachedProfile();
      if (cachedData != null) {
        return cachedData;
      }

      // Fetch user data from YouTube API
      final response = await http.get(
        Uri.parse('$_youtubeApiBase/channels?part=snippet&mine=true&key=$apiKey'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if ((data['items'] as List).isEmpty) {
          throw Exception('No YouTube channel data found for this user');
        }

        final channel = data['items'][0]['snippet'];
        final userModel = UserModel(
          id: data['items'][0]['id'],
          username: '@${channel['title'].replaceAll(' ', '').toLowerCase()}',
          displayName: channel['title'],
          email: '', // YouTube API does not return email
          profilePicUrl: channel['thumbnails']['default']['url'],
          accessToken: accessToken,
          additionalData: {
            'description': channel['description'],
            'publishedAt': channel['publishedAt'],
          },
        );

        // Cache the data for future use
        await _cacheProfile(userModel);

        return userModel;
      } else {
        throw Exception('Failed to fetch YouTube profile data: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching user profile: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _clearProfileCache();
    } catch (e) {
      throw Exception('Failed to sign out: ${e.toString()}');
    }
  }

  // Cache profile data locally
  Future<void> _cacheProfile(UserModel profile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_cacheKey, jsonEncode(profile.toJson()));
    } catch (e) {
      print('Error caching profile: $e');
    }
  }

  // Retrieve cached profile data
  Future<UserModel?> _getCachedProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString(_cacheKey);
      if (cachedData != null) {
        return UserModel.fromJson(jsonDecode(cachedData));
      }
      return null;
    } catch (e) {
      print('Error retrieving cached profile: $e');
      return null;
    }
  }

  // Clear cached profile data
  Future<void> _clearProfileCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cacheKey);
    } catch (e) {
      print('Error clearing profile cache: $e');
    }
  }
}
