import 'dart:convert';
import 'package:iptv/core/models/history_item.dart';
import 'package:iptv/core/services/cache_helper.dart';

class HistoryService {
  static const String _historyKey = 'watch_history';
  static const int _maxHistoryItems = 100;
  final CacheHelper _cacheHelper;

  HistoryService(this._cacheHelper);

  // Get all history items
  Future<List<HistoryItem>> getHistory() async {
    try {
      final String? historyJson = _cacheHelper.getDataString(key: _historyKey);
      
      if (historyJson == null || historyJson.isEmpty) {
        return [];
      }

      final List<dynamic> historyList = jsonDecode(historyJson);
      final result = historyList
          .map((item) => HistoryItem.fromJson(item as Map<String, dynamic>))
          .toList();
      
      // Sort by most recent first
      result.sort((a, b) => b.watchedAt.compareTo(a.watchedAt));
      
      return result;
    } catch (e) {
      return [];
    }
  }

  // Add item to history
  Future<bool> addToHistory(HistoryItem item) async {
    try {
      List<HistoryItem> history = await getHistory();
      
      // Remove duplicate entries (same id and type)
      history.removeWhere((h) => h.id == item.id && h.type == item.type);
      
      // Add new item at the beginning
      history.insert(0, item);
      
      // Keep only the last N items
      if (history.length > _maxHistoryItems) {
        history = history.sublist(0, _maxHistoryItems);
      }
      
      final String jsonString = jsonEncode(history.map((e) => e.toJson()).toList());
      final result = await _cacheHelper.saveData(key: _historyKey, value: jsonString);
      
      return result;
    } catch (e) {
      return false;
    }
  }

  // Remove specific item from history
  Future<bool> removeFromHistory(String id, String type) async {
    try {
      final history = await getHistory();
      history.removeWhere((h) => h.id == id && h.type == type);
      
      final String jsonString = jsonEncode(history.map((e) => e.toJson()).toList());
      final result = await _cacheHelper.saveData(key: _historyKey, value: jsonString);
      
      return result;
    } catch (e) {
      return false;
    }
  }

  // Get history by type
  Future<List<HistoryItem>> getHistoryByType(String type) async {
    final history = await getHistory();
    return history.where((h) => h.type == type).toList();
  }

  // Clear all history
  Future<bool> clearHistory() async {
    try {
      return await _cacheHelper.removeData(key: _historyKey);
    } catch (e) {
      return false;
    }
  }

  // Check if item exists in history
  Future<bool> isInHistory(String id, String type) async {
    final history = await getHistory();
    return history.any((h) => h.id == id && h.type == type);
  }

  // Get recent items (last N items)
  Future<List<HistoryItem>> getRecentHistory({int limit = 10}) async {
    final history = await getHistory();
    return history.take(limit).toList();
  }
}
