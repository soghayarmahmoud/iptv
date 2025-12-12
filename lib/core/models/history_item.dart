import 'dart:convert';

class HistoryItem {
  final String id;
  final String name;
  final String imageUrl;
  final String streamUrl;
  final String type; // 'live_tv', 'movie', 'episode'
  final DateTime watchedAt;
  final int? watchDuration; // in seconds
  
  // For episodes
  final String? seriesId;
  final String? episodeId;
  final String? seriesName;
  final String? episodeNumber;
  
  // For live TV
  final String? channelId;
  final String? channelIcon;
  final String? categoryId;
  
  HistoryItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.streamUrl,
    required this.type,
    required this.watchedAt,
    this.watchDuration,
    this.seriesId,
    this.episodeId,
    this.seriesName,
    this.episodeNumber,
    
    this.channelId,
    this.channelIcon,
    this.categoryId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'streamUrl': streamUrl,
      'type': type,
      'watchedAt': watchedAt.toIso8601String(),
      'watchDuration': watchDuration,
      'seriesId': seriesId,
      'episodeId': episodeId,
      'seriesName': seriesName,
      'episodeNumber': episodeNumber,
      'channelId': channelId,
      'channelIcon': channelIcon,
      'categoryId': categoryId,
    };
  }

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      streamUrl: json['streamUrl'] ?? '',
      type: json['type'] ?? 'movie',
      watchedAt: DateTime.parse(json['watchedAt'] ?? DateTime.now().toIso8601String()),
      watchDuration: json['watchDuration'],
      seriesId: json['seriesId'],
      episodeId: json['episodeId'],
      seriesName: json['seriesName'],
      episodeNumber: json['episodeNumber'],
      channelId: json['channelId'],
      channelIcon: json['channelIcon'],
      categoryId: json['categoryId'],
    );
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }

  factory HistoryItem.fromJsonString(String jsonString) {
    return HistoryItem.fromJson(jsonDecode(jsonString));
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HistoryItem && 
           other.id == id && 
           other.type == type &&
           other.watchedAt == watchedAt;
  }

  @override
  int get hashCode => id.hashCode ^ type.hashCode ^ watchedAt.hashCode;
}
