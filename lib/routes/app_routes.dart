import 'package:flutter/material.dart';
import 'package:my_focus/screens/home/bottomNavigationBar/library_page.dart';
import 'package:my_focus/screens/home/extra/channel_info_page.dart';
import 'package:my_focus/screens/home/navigationDrawer/about_page.dart';
import 'package:my_focus/screens/home/navigationDrawer/downloads_page.dart';
import 'package:my_focus/screens/home/bottomNavigationBar/home_page.dart';
import 'package:my_focus/screens/auth/forget_pass_page.dart';
import 'package:my_focus/screens/auth/login_page.dart';
import 'package:my_focus/screens/auth/signup_page.dart';
import 'package:my_focus/screens/home/navigationDrawer/channels_page.dart';
import 'package:my_focus/screens/home/bottomNavigationBar/player_page.dart';
import 'package:my_focus/screens/home/navigationDrawer/profile_page.dart';
import 'package:my_focus/screens/home/navigationDrawer/settings_page.dart';
import 'package:my_focus/screens/home/navigationDrawer/statistics_page.dart';

// Routes for authenticated users
class AppRoutes {
  //Navigation Bar routes
  static const String home = '/home';
  static const String player = '/player';
  static const String library = "/library";

  //Navigation Drawer routes
  static const String profile = '/profile';
  static const String download = "/download";
  static const String channels = '/channels';
  static const String statistics = "/statistics";
  static const String settings = '/settings';
  static const String about = '/about';

  //Extra routes
  static const String channelInfo = '/channelInfo';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      ///NAvigation BAR
      home: (context) => HomeScreen(
            key: ValueKey("home"),
          ),
      player: (context) => PlayerScreen(
            key: ValueKey("player"),
          ),
      library: (context) => LibraryScreen(
            key: ValueKey('library'),
          ),

      /// Navigation Drawer
      profile: (context) => ProfileScreen(
            key: ValueKey("profile"),
          ),
      download: (context) => DownloadsPage(
            key: ValueKey("download"),
          ),
      channels: (context) => ChannelsPage(
            key: ValueKey("channels"),
          ),
      statistics: (context) => StatisticsPage(
            key: ValueKey("statistics"),
          ),
      settings: (context) => SettingsPage(
            key: ValueKey("settings"),
          ),
      about: (context) => AboutPage(
            key: ValueKey("about"),
          ),

      ///EXTRA ROUTES
      channelInfo: (context) => ChannelInfoPage(
            key: ValueKey("channelInfo"),
          )
    };
  }
}

// Routes for unauthenticated users
class AuthRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot_password';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => LoginScreen(
            key: ValueKey('login'),
          ),
      signup: (context) => SignupScreen(
            key: ValueKey("signup"),
          ),
      forgotPassword: (context) => ForgotPasswordPage(
            key: ValueKey("forgot"),
          )
    };
  }
}
