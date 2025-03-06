import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_focus/models/channel_model.dart';

class HiveService {
  // Singleton pattern
  static final HiveService _instance = HiveService._internal();
  factory HiveService() => _instance;
  HiveService._internal();

  // Track initialization state
  bool _isInitialized = false;

  /// Initialize Hive and register all adapters
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    // Initialize Hive
    await Hive.initFlutter();
    
    // Register all adapters
    _registerAdapters();
    
    // Mark as initialized
    _isInitialized = true;
  }

  /// Register all Hive type adapters
  void _registerAdapters() {
    if (!Hive.isAdapterRegistered(ChannelAdapter().typeId)) {
      Hive.registerAdapter(ChannelAdapter());
    }
    // Add other adapters as needed
  }

  /// Open a box with the given name
  Future<Box<T>> openBox<T>(String boxName) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<T>(boxName);
    }
    
    return await Hive.openBox<T>(boxName);
  }

  /// Close a specific box
  Future<void> closeBox(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      await Hive.box(boxName).close();
    }
  }

  /// Close all open boxes
  Future<void> closeAllBoxes() async {
    await Hive.close();
  }
}