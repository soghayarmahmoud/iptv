// Episode stream response models

import 'package:iptv/featuers/series/data/models/eposide_model.dart';

class EpisodeStreamResponse {
  final bool success;
  final EpisodeStream episode;

  const EpisodeStreamResponse({
    required this.success,
    required this.episode,
  });

  factory EpisodeStreamResponse.fromJson(Map<String, dynamic> json) {
    return EpisodeStreamResponse(
      success: (json['success'] as bool?) ?? false,
      episode: EpisodeStream.fromJson(
        (json['episode'] as Map<String, dynamic>? ?? <String, dynamic>{}),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'success': success,
      'episode': episode.toJson(),
    };
  }
}

class EpisodeStream {
  final String id;
  final String name;
   String streamUrl;
  final int episodeNumber;
  final int seasonNumber;
  final OriginalEpisodeData originalData;
  final String? originalUrl;

   EpisodeStream({
    required this.id,
    required this.name,
    required this.originalUrl,
    
    required this.streamUrl,
    required this.episodeNumber,
    required this.seasonNumber,
    required this.originalData,
  });

  factory EpisodeStream.fromJson(Map<String, dynamic> json) {
    return EpisodeStream(
      id: _asString(json['id']),
      originalUrl: _asString(json['originalUrl']),
      
      name: _asString(json['name']),
      streamUrl: _asString(json['streamUrl']),
      episodeNumber: _asInt(json['episodeNumber']),
      seasonNumber: _asInt(json['seasonNumber']),
      originalData: OriginalEpisodeData.fromJson(
        (json['originalData'] as Map<String, dynamic>? ?? <String, dynamic>{}),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'streamUrl': streamUrl,
      'episodeNumber': episodeNumber,
      'seasonNumber': seasonNumber,
      'originalData': originalData.toJson(),
      'originalUrl': originalUrl,
      
    };
  }
}

class OriginalEpisodeData {
  final String id;
  final int episodeNum;
  final String title;
  final String containerExtension;
  final EpisodeInfo info; // reuse from eposide_model.dart
  final String? customSid;
  final String added;
  final int season;
  final String directSource;

  const OriginalEpisodeData({
    required this.id,
    required this.episodeNum,
    required this.title,
    required this.containerExtension,
    required this.info,
    required this.customSid,
    required this.added,
    required this.season,
    required this.directSource,
  });

  factory OriginalEpisodeData.fromJson(Map<String, dynamic> json) {
    return OriginalEpisodeData(
      id: _asString(json['id']),
      episodeNum: _asInt(json['episode_num']),
      title: _asString(json['title']),
      containerExtension: _asString(json['container_extension']),
      info: EpisodeInfo.fromJson(
        (json['info'] as Map<String, dynamic>? ?? <String, dynamic>{}),
      ),
      customSid: _asNullableString(json['custom_sid']),
      added: _asString(json['added']),
      season: _asInt(json['season']),
      directSource: _asString(json['direct_source']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'episode_num': episodeNum,
      'title': title,
      'container_extension': containerExtension,
      'info': info.toJson(),
      'custom_sid': customSid,
      'added': added,
      'season': season,
      'direct_source': directSource,
    };
  }
}

// Local parsing helpers mirroring eposide_model.dart
String _asString(dynamic value) {
  if (value == null) return '';
  if (value is String) return value;
  return value.toString();
}

String? _asNullableString(dynamic value) {
  if (value == null) return null;
  if (value is String) return value;
  return value.toString();
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) {
    final parsed = int.tryParse(value);
    if (parsed != null) return parsed;
  }
  return 0;
}


