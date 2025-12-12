import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoService {
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  
  /// Gets the best available device identifier
  /// Note: Real MAC addresses are not accessible on modern mobile platforms
  /// This returns Android ID on Android and identifierForVendor on iOS
  static Future<String> getDeviceId() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        // Android ID is a unique 64-bit identifier
        return androidInfo.id.isNotEmpty ? androidInfo.id : 'unknown-android';
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        // identifierForVendor is unique per app vendor
        return iosInfo.identifierForVendor?.isNotEmpty == true ? iosInfo.identifierForVendor! : 'unknown-ios';
      } else if (Platform.isMacOS) {
        final macInfo = await _deviceInfo.macOsInfo;
        return macInfo.systemGUID?.isNotEmpty == true ? macInfo.systemGUID! : 'unknown-macos';
      } else if (Platform.isWindows) {
        final windowsInfo = await _deviceInfo.windowsInfo;
        return windowsInfo.deviceId.isNotEmpty ? windowsInfo.deviceId : 'unknown-windows';
      } else if (Platform.isLinux) {
        final linuxInfo = await _deviceInfo.linuxInfo;
        return linuxInfo.machineId?.isNotEmpty == true ? linuxInfo.machineId! : 'unknown-linux';
      }
      return 'unknown-platform';
    } catch (e) {
      return 'error-getting-id';
    }
  }

  /// Formats device ID to look like a MAC address for display purposes
  static String formatAsMAC(String deviceId) {
    // Take first 12 characters and format as MAC address
    String cleanId = deviceId.replaceAll(RegExp(r'[^a-fA-F0-9]'), '').toLowerCase();
    
    if (cleanId.length < 12) {
      // Pad with zeros if too short
      cleanId = cleanId.padRight(12, '0');
    } else if (cleanId.length > 12) {
      // Take first 12 characters if too long
      cleanId = cleanId.substring(0, 12);
    }
    
    // Format as MAC address (xx:xx:xx:xx:xx:xx)
    return '${cleanId.substring(0, 2)}:${cleanId.substring(2, 4)}:${cleanId.substring(4, 6)}:${cleanId.substring(6, 8)}:${cleanId.substring(8, 10)}:${cleanId.substring(10, 12)}';
  }

  /// Gets device model information
  static Future<String> getDeviceModel() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        return '${androidInfo.brand} ${androidInfo.model}';
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        return iosInfo.model.isNotEmpty ? iosInfo.model : 'Unknown iOS Device';
      } else if (Platform.isMacOS) {
        final macInfo = await _deviceInfo.macOsInfo;
        return macInfo.model.isNotEmpty ? macInfo.model : 'Unknown Mac';
      } else if (Platform.isWindows) {
        final windowsInfo = await _deviceInfo.windowsInfo;
        return windowsInfo.productName.isNotEmpty ? windowsInfo.productName : 'Unknown Windows Device';
      } else if (Platform.isLinux) {
        final linuxInfo = await _deviceInfo.linuxInfo;
        return linuxInfo.prettyName.isNotEmpty ? linuxInfo.prettyName : 'Unknown Linux Device';
      }
      return 'Unknown Device';
    } catch (e) {
      return 'Error getting device model';
    }
  }
}
