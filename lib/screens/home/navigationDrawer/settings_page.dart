import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: [
          _buildSettingsItem(
            context,
            icon: Icons.tune,
            iconColor: Colors.blue,
            title: 'General',
            subtitle: 'App language, notifications',
          ),
          _buildSettingsItem(
            context,
            icon: Icons.palette_outlined,
            iconColor: Colors.indigo,
            title: 'Appearance',
            subtitle: 'Theme, date & time format',
          ),
          _buildSettingsItem(
            context,
            icon: Icons.collections_bookmark_outlined,
            iconColor: Colors.blue,
            title: 'Library',
            subtitle: 'Categories, global update',
          ),
          _buildSettingsItem(
            context,
            icon: Icons.chrome_reader_mode_outlined,
            iconColor: Colors.blue,
            title: 'Reader',
            subtitle: 'Reading mode, display, navigation',
          ),
          _buildSettingsItem(
            context,
            icon: Icons.download_outlined,
            iconColor: Colors.blue,
            title: 'Downloads',
            subtitle: 'Automatic download, download ahead',
          ),
          _buildSettingsItem(
            context,
            icon: Icons.sync_outlined,
            iconColor: Colors.blue,
            title: 'Tracking',
            subtitle: 'One-way progress sync, enhanced sync',
          ),
          _buildSettingsItem(
            context,
            icon: Icons.explore_outlined,
            iconColor: Colors.blue,
            title: 'Browse',
            subtitle: 'Sources, extensions, global search',
          ),
          _buildSettingsItem(
            context,
            icon: Icons.restore_outlined,
            iconColor: Colors.blue,
            title: 'Backup and restore',
            subtitle: 'Manual & automatic backups',
          ),
          _buildSettingsItem(
            context,
            icon: Icons.shield_outlined,
            iconColor: Colors.blue,
            title: 'Security',
            subtitle: 'App lock, secure screen',
          ),
          _buildSettingsItem(
            context,
            icon: Icons.code_outlined,
            iconColor: Colors.blue,
            title: 'Advanced',
            subtitle: 'Dump crash logs, battery optimizations',
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Icon(
          icon,
          color: iconColor,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: Theme.of(context).textTheme.bodySmall?.color,
        ),
      ),
      onTap: () {},
    );
  }
}