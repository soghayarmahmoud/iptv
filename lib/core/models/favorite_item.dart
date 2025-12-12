import 'dart:convert';

class FavoriteItem {
  final String id;
  final String name;
  final String imageUrl;
  final String streamUrl;
  final String? originalUrl;
  final String type; // 'movie' or 'episode'
  final DateTime addedAt;
  
  // For episodes
  final String? seriesId;
  final String? episodeId;
  final String? seriesName;
  
  final String? channelIcon;
  FavoriteItem({
    required this.id,
    required this.name,
    required this.imageUrl,

    required this.streamUrl,
    required this.type,
    required this.addedAt,
    this.seriesId,
    this.episodeId,
    this.originalUrl,
    this.channelIcon,
    
    this.seriesName,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'streamUrl': streamUrl,
      'type': type,
      'addedAt': addedAt.toIso8601String(),
      'seriesId': seriesId,
      'originalUrl': originalUrl,
      'channelIcon': channelIcon,
      
      'episodeId': episodeId,
      'seriesName': seriesName,
    };
  }

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    return FavoriteItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      streamUrl: json['streamUrl'] ?? '',
      type: json['type'] ?? 'movie',
      addedAt: DateTime.parse(json['addedAt'] ?? DateTime.now().toIso8601String()),
      seriesId: json['seriesId'],
      originalUrl: json['originalUrl'],
      episodeId: json['episodeId'],
      channelIcon: json['channelIcon'],
      seriesName: json['seriesName'],
    );
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }

  factory FavoriteItem.fromJsonString(String jsonString) {
    return FavoriteItem.fromJson(jsonDecode(jsonString));
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FavoriteItem && other.id == id && other.type == type;
  }

  @override
  int get hashCode => id.hashCode ^ type.hashCode;
}
