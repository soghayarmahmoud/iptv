import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();


Future<void> saveToken(String token) async {
  await storage.write(key: 'token', value: token);
}

Future<String?> getToken() async {
  return await storage.read(key: 'token');
}

Future<void> deleteToken() async {
  await storage.delete(key: 'token');
}


Future<String?> getPlaylistId() async {
  return await storage.read(key: 'playlist_id');
}

Future<void> savePlaylistId(String playlistId) async {
  await storage.write(key: 'playlist_id', value: playlistId);
}

Future<void> deletePlaylistId() async {
  await storage.delete(key: 'playlist_id');
}

Future<void> saveCustomId(String customId) async {
  await storage.write(key: 'custom_id', value: customId);
}

Future<String?> getCustomId() async {
  return await storage.read(key: 'custom_id');
}

Future<void> deleteCustomId() async {
  await storage.delete(key: 'custom_id');
}

Future<void> clearStorage() async {
  await storage.deleteAll();
}

