import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:device_info_plus/device_info_plus.dart';

/// Memory manager to detect low-end devices and optimize memory usage
/// This helps prevent OOM (Out of Memory) crashes on 1-2GB RAM Android TV boxes
class MemoryManager {
  static final MemoryManager _instance = MemoryManager._internal();
  factory MemoryManager() => _instance;
  MemoryManager._internal();

  bool _isLowEndDevice = false;
  bool get isLowEndDevice => _isLowEndDevice;

  /// Initialize and detect if device is low-end
  /// SAFE: Returns false on any error to prevent crashes
  Future<void> initialize() async {
    try {
      if (Platform.isAndroid) {
        final deviceInfo = DeviceInfoPlugin();
        final androidInfo = await deviceInfo.androidInfo;
        
        // Heuristic: Devices with Android < 8.0 are usually low-end
        final sdkInt = androidInfo.version.sdkInt ?? 26; // Default to 26 if null
        final isOldDevice = sdkInt < 26; // Android < 8.0
        
        _isLowEndDevice = isOldDevice;
        
        debugPrint('📊 Device Info: SDK=$sdkInt, Model=${androidInfo.model ?? "Unknown"}, LowEnd=$_isLowEndDevice');
      } else {
        // Not Android, assume normal device
        _isLowEndDevice = false;
        debugPrint('📊 Non-Android platform detected, using normal cache sizes');
      }
    } catch (e) {
      // SAFE: On any error, assume normal device to prevent crashes
      debugPrint(' Memory manager initialization error: $e');
      debugPrint(' Defaulting to normal device settings');
      _isLowEndDevice = false;
    }
  }

  /// Suggested image cache size in MB based on device
  int get imageCacheSizeMB => _isLowEndDevice ? 50 : 100;
  
  /// Maximum number of cached images
  int get maxCachedImages => _isLowEndDevice ? 50 : 100;
  
  /// Suggested video buffer size in MB
  int get videoBufferSizeMB => _isLowEndDevice ? 5 : 10;
}
