import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_focus/core/services/hive_service.dart';
import 'app.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  // Initialize Hive service
  await HiveService().initialize();
  
  // Run the app with ProviderScope for Riverpod
  runApp(
    ProviderScope(
      child: RootApp(key: const ValueKey("rootApp")),
    ),
  );
}