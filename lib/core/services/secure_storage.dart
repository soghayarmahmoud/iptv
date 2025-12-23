import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

Future<void> saveToken(String token) async {
  try {
    await storage.write(key: 'token', value: token);
  } catch (e) {
    debugPrint('Error saving token: $e');
  }
}

Future<String?> getToken() async {
  try {
    return await storage.read(key: 'token');
  } catch (e) {
    debugPrint('Error reading token: $e');
    return null;
  }
}

Future<void> deleteToken() async {
  try {
    await storage.delete(key: 'token');
  } catch (e) {
    debugPrint('Error deleting token: $e');
  }
}

Future<String?> getPlaylistId() async {
  try {
    return await storage.read(key: 'playlist_id');
  } catch (e) {
    debugPrint('Error reading playlist_id: $e');
    return null;
  }
}

Future<void> savePlaylistId(String playlistId) async {
  try {
    await storage.write(key: 'playlist_id', value: playlistId);
  } catch (e) {
    debugPrint('Error saving playlist_id: $e');
  }
}

Future<void> deletePlaylistId() async {
  try {
    await storage.delete(key: 'playlist_id');
  } catch (e) {
    debugPrint('Error deleting playlist_id: $e');
  }
}

Future<void> saveCustomId(String customId) async {
  try {
    await storage.write(key: 'custom_id', value: customId);
  } catch (e) {
    debugPrint('Error saving custom_id: $e');
  }
}

Future<String?> getCustomId() async {
  try {
    return await storage.read(key: 'custom_id');
  } catch (e) {
    debugPrint('Error reading custom_id: $e');
    return null;
  }
}

Future<void> deleteCustomId() async {
  try {
    await storage.delete(key: 'custom_id');
  } catch (e) {
    debugPrint('Error deleting custom_id: $e');
  }
}

Future<void> clearStorage() async {
  try {
    await storage.deleteAll();
  } catch (e) {
    debugPrint('Error clearing storage: $e');
  }
}
