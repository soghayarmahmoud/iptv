// Models for Movies content (list of VOD movies) response

class MoviesContentResponse {
  final bool success;
  final List<MovieItem> content;
  final int totalContent;
  final String categoryId;

  const MoviesContentResponse({
    required this.success,
    required this.content,
    required this.totalContent,
    required this.categoryId,
  });

  factory MoviesContentResponse.fromJson(Map<String, dynamic> json) {
    final contentJson = json['content'] as List<dynamic>?;
    return MoviesContentResponse(
      success: (json['success'] as bool?) ?? false,
      content: contentJson == null
          ? const <MovieItem>[]
          : contentJson
              .whereType<Map<String, dynamic>>()
              .map(MovieItem.fromJson)
              .toList(),
      totalContent: _asInt(json['totalContent']),
      categoryId: _asString(json['categoryId']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'success': success,
      'content': content.map((e) => e.toJson()).toList(),
      'totalContent': totalContent,
      'categoryId': categoryId,
    };
  }
}

class MovieItem {
  final String id;
  final String name;
  final String streamType;
  final String icon;
  final String categoryId;
  final String added;
  final String rating;
  final double rating5based;
  final String streamUrl;
  final OriginalMovieData originalData;
  final String? originalUrl;

  const MovieItem({
    required this.id,
    required this.name,
    required this.streamType,
    required this.icon,
    required this.categoryId,
    required this.originalUrl,
    
    required this.added,
    required this.rating,
    required this.rating5based,
    required this.streamUrl,
    required this.originalData,
  });

  factory MovieItem.fromJson(Map<String, dynamic> json) {
    return MovieItem(
      id: _asString(json['id']),
      name: _asString(json['name']),
      streamType: _asString(json['streamType']),
      originalUrl: _asString(json['originalUrl']),
      
      icon: _asString(json['icon']),
      categoryId: _asString(json['categoryId']),
      added: _asString(json['added']),
      rating: _asString(json['rating']),
      rating5based: _asDouble(json['rating5based']),
      streamUrl: _asString(json['streamUrl']),
      originalData: OriginalMovieData.fromJson(
        (json['originalData'] as Map<String, dynamic>? ?? <String, dynamic>{}),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'streamType': streamType,
      'icon': icon,
      'categoryId': categoryId,
      'added': added,
      'rating': rating,
      'rating5based': rating5based,
      'streamUrl': streamUrl,
      'originalData': originalData.toJson(),
      'originalUrl': originalUrl
    };
  }
}

class OriginalMovieData {
  final int numIndex;
  final String name;
  final String streamType;
  final int streamId;
  final String streamIcon;
  final String rating;
  final double rating5based;
  final String added;
  final String categoryId;
  final String containerExtension;
  final dynamic customSid;
  final String directSource;

  const OriginalMovieData({
    required this.numIndex,
    required this.name,
    required this.streamType,
    required this.streamId,
    required this.streamIcon,
    required this.rating,
    required this.rating5based,
    required this.added,
    required this.categoryId,
    required this.containerExtension,
    required this.customSid,
    required this.directSource,
  });

  factory OriginalMovieData.fromJson(Map<String, dynamic> json) {
    return OriginalMovieData(
      numIndex: _asInt(json['num']),
      name: _asString(json['name']),
      streamType: _asString(json['stream_type']),
      streamId: _asInt(json['stream_id']),
      streamIcon: _asString(json['stream_icon']),
      rating: _asString(json['rating']),
      rating5based: _asDouble(json['rating_5based']),
      added: _asString(json['added']),
      categoryId: _asString(json['category_id']),
      containerExtension: _asString(json['container_extension']),
      customSid: json['custom_sid'],
      directSource: _asString(json['direct_source']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'num': numIndex,
      'name': name,
      'stream_type': streamType,
      'stream_id': streamId,
      'stream_icon': streamIcon,
      'rating': rating,
      'rating_5based': rating5based,
      'added': added,
      'category_id': categoryId,
      'container_extension': containerExtension,
      'custom_sid': customSid,
      'direct_source': directSource,
    };
  }
}

String _asString(dynamic value) {
  if (value == null) return '';
  if (value is String) return value;
  return value.toString();
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is String) {
    final parsed = int.tryParse(value);
    return parsed ?? 0;
  }
  if (value is double) return value.toInt();
  return 0;
}

double _asDouble(dynamic value) {
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) {
    final parsed = double.tryParse(value);
    return parsed ?? 0.0;
  }
  return 0.0;
}


