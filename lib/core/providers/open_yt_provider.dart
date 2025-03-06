import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OpenYouTubeButton extends StatelessWidget {
  final String channelId; // Example: "UC_x5XG1OV2P6uZZ5FSM9Ttw"

  const OpenYouTubeButton({super.key, required this.channelId});

  Future<void> _launchYouTube() async {
    final Uri youtubeAppUrl = Uri.parse("youtube://channel/$channelId"); // Opens in YouTube app
    final Uri youtubeWebUrl = Uri.parse("https://www.youtube.com/channel/$channelId"); // Fallback for browser

    if (await canLaunchUrl(youtubeAppUrl)) {
      await launchUrl(youtubeAppUrl, mode: LaunchMode.externalApplication);
    } else if (await canLaunchUrl(youtubeWebUrl)) {
      await launchUrl(youtubeWebUrl, mode: LaunchMode.externalApplication);
    } else {
      throw "Could not open YouTube";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      label: Text("Open in YouTube"),
      onPressed: _launchYouTube,
      icon: Icon(Icons.smart_display),
    );
  }
}
