// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'package:iptv/core/models/favorite_item.dart';
import 'package:iptv/core/services/cache_helper.dart';

class FavoriteService {
  static const String _favoritesKey = 'favorites_list';
  final CacheHelper _cacheHelper;

  FavoriteService(this._cacheHelper);

  // Get all favorites
  Future<List<FavoriteItem>> getFavorites() async {
    try {
      final String? favoritesJson = _cacheHelper.getDataString(key: _favoritesKey);
      
      if (favoritesJson == null || favoritesJson.isEmpty) {
        return [];
      }

      final List<dynamic> favoritesList = jsonDecode(favoritesJson);
      final result = favoritesList
          .map((item) => FavoriteItem.fromJson(item as Map<String, dynamic>))
          .toList();
      return result;
    } catch (e) {
      return [];
    }
  }

  // Add to favorites
  Future<bool> addToFavorites(FavoriteItem item) async {
    try {
      final favorites = await getFavorites();
      
      // Check if already exists
      if (favorites.any((fav) => fav.id == item.id && fav.type == item.type)) {
        return true; // Already in favorites
      }

      favorites.add(item);
      final String jsonString = jsonEncode(favorites.map((e) => e.toJson()).toList());
      final result = await _cacheHelper.saveData(key: _favoritesKey, value: jsonString);
      return result;
    } catch (e) {
      return false;
    }
  }

  // Remove from favorites
  Future<bool> removeFromFavorites(String id, String type) async {
    try {
      final favorites = await getFavorites();
      final initialCount = favorites.length;
      favorites.removeWhere((fav) => fav.id == id && fav.type == type);
      
      final String jsonString = jsonEncode(favorites.map((e) => e.toJson()).toList());
      final result = await _cacheHelper.saveData(key: _favoritesKey, value: jsonString);
      return result;
    } catch (e) {
      return false;
    }
  }

  // Check if item is favorite
  Future<bool> isFavorite(String id, String type) async {
    try {
      final favorites = await getFavorites();
      final result = favorites.any((fav) => fav.id == id && fav.type == type);
      return result;
    } catch (e) {
      return false;
    }
  }

  // Toggle favorite
  Future<bool> toggleFavorite(FavoriteItem item) async {
    
    final isFav = await isFavorite(item.id, item.type);
    
    bool result;
    if (isFav) {
      result = await removeFromFavorites(item.id, item.type);
    } else {
      result = await addToFavorites(item);
    }
    
    // Verify the change
    final newState = await isFavorite(item.id, item.type);
    
    return result;
  }

  // Get favorites by type
  Future<List<FavoriteItem>> getFavoritesByType(String type) async {
    final favorites = await getFavorites();
    return favorites.where((fav) => fav.type == type).toList();
  }

  // Clear all favorites
  Future<bool> clearFavorites() async {
    return await _cacheHelper.removeData(key: _favoritesKey);
  }
}
