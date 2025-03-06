import 'package:hive/hive.dart';

part 'channel_model.g.dart';

@HiveType(typeId: 0)
class Channel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String thumbnailUrl;

  @HiveField(4)
  bool isBlocked; // Added isBlocked property

  Channel({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    this.isBlocked = true, // Default to blocked
  });

  // Factory constructor to create a Channel from YouTube API JSON
  factory Channel.fromJson(Map<String, dynamic> json) {
    final snippet = json['snippet'];
    final thumbnails = snippet['thumbnails'];
    final channelId = snippet['resourceId']?['channelId'] ?? '';
    
    return Channel(
      id: channelId,
      title: snippet['title'] ?? '',
      description: snippet['description'] ?? '',
      thumbnailUrl: thumbnails['medium']?['url'] ?? 
                   thumbnails['default']?['url'] ?? 
                   '',
      isBlocked: true, // Default to blocked
    );
  }

  // Update isBlocked status
  void setBlocked(bool blocked) {
    isBlocked = blocked;
    save(); // Save to Hive
  }

  @override
  String toString() {
    return 'Channel{id: $id, title: $title, isBlocked: $isBlocked}';
  }
}