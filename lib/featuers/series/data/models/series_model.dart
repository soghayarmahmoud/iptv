// Models for Series content (list of VOD series) response

class SeriesContentResponse {
  final bool success;
  final List<SeriesItem> content;
  final int totalContent;
  final String categoryId;

  const SeriesContentResponse({
    required this.success,
    required this.content,
    required this.totalContent,
    required this.categoryId,
  });

  factory SeriesContentResponse.fromJson(Map<String, dynamic> json) {
    final contentJson = json['content'] as List<dynamic>?;
    return SeriesContentResponse(
      success: (json['success'] as bool?) ?? false,
      content: contentJson == null
          ? const <SeriesItem>[]
          : contentJson
              .whereType<Map<String, dynamic>>()
              .map(SeriesItem.fromJson)
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

class SeriesItem {
  final String id;
  final String name;
  final String streamType;
  final String icon;
  final String categoryId;
  final String plot;
  final String cast;
  final String director;
  final String genre;
  final String releaseDate;
  final String rating;
  final double rating5based;
  final OriginalSeriesData originalData;

  const SeriesItem({
    required this.id,
    required this.name,
    required this.streamType,
    required this.icon,
    required this.categoryId,
    required this.plot,
    required this.cast,
    required this.director,
    required this.genre,
    required this.releaseDate,
    required this.rating,
    required this.rating5based,
    required this.originalData,
  });

  factory SeriesItem.fromJson(Map<String, dynamic> json) {
    return SeriesItem(
      id: _asString(json['id']),
      name: _asString(json['name']),
      streamType: _asString(json['streamType']),
      icon: _asString(json['icon']),
      categoryId: _asString(json['categoryId']),
      plot: _asString(json['plot']),
      cast: _asString(json['cast']),
      director: _asString(json['director']),
      genre: _asString(json['genre']),
      releaseDate: _asString(json['releaseDate']),
      rating: _asString(json['rating']),
      rating5based: _asDouble(json['rating5based']),
      originalData: OriginalSeriesData.fromJson(
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
      'plot': plot,
      'cast': cast,
      'director': director,
      'genre': genre,
      'releaseDate': releaseDate,
      'rating': rating,
      'rating5based': rating5based,
      'originalData': originalData.toJson(),
    };
  }

  @override
  String toString() {
    return 'SeriesItem(id: $id, name: $name, streamType: $streamType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SeriesItem &&
        other.id == id &&
        other.name == name &&
        other.streamType == streamType;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ streamType.hashCode;
  }
}

class OriginalSeriesData {
  final int num;
  final String name;
  final int seriesId;
  final String cover;
  final String plot;
  final String cast;
  final String director;
  final String genre;
  final String releaseDate;
  final String lastModified;
  final String rating;
  final double rating5based;
  final List<String> backdropPath;
  final String youtubeTrailer;
  final String episodeRunTime;
  final String categoryId;

  const OriginalSeriesData({
    required this.num,
    required this.name,
    required this.seriesId,
    required this.cover,
    required this.plot,
    required this.cast,
    required this.director,
    required this.genre,
    required this.releaseDate,
    required this.lastModified,
    required this.rating,
    required this.rating5based,
    required this.backdropPath,
    required this.youtubeTrailer,
    required this.episodeRunTime,
    required this.categoryId,
  });

  factory OriginalSeriesData.fromJson(Map<String, dynamic> json) {
    return OriginalSeriesData(
      num: _asInt(json['num']),
      name: _asString(json['name']),
      seriesId: _asInt(json['series_id']),
      cover: _asString(json['cover']),
      plot: _asString(json['plot']),
      cast: _asString(json['cast']),
      director: _asString(json['director']),
      genre: _asString(json['genre']),
      releaseDate: _asString(json['releaseDate']),
      lastModified: _asString(json['last_modified']),
      rating: _asString(json['rating']),
      rating5based: _asDouble(json['rating_5based']),
      backdropPath: _asStringList(json['backdrop_path']),
      youtubeTrailer: _asString(json['youtube_trailer']),
      episodeRunTime: _asString(json['episode_run_time']),
      categoryId: _asString(json['category_id']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'num': num,
      'name': name,
      'series_id': seriesId,
      'cover': cover,
      'plot': plot,
      'cast': cast,
      'director': director,
      'genre': genre,
      'releaseDate': releaseDate,
      'last_modified': lastModified,
      'rating': rating,
      'rating_5based': rating5based,
      'backdrop_path': backdropPath,
      'youtube_trailer': youtubeTrailer,
      'episode_run_time': episodeRunTime,
      'category_id': categoryId,
    };
  }

  @override
  String toString() {
    return 'OriginalSeriesData(seriesId: $seriesId, name: $name, genre: $genre)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OriginalSeriesData &&
        other.seriesId == seriesId &&
        other.name == name &&
        other.genre == genre;
  }

  @override
  int get hashCode {
    return seriesId.hashCode ^ name.hashCode ^ genre.hashCode;
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

List<String> _asStringList(dynamic value) {
  if (value == null) return [];
  if (value is List) {
    return value
        .map((e) => _asString(e))
        .where((e) => e.isNotEmpty)
        .toList();
  }
  return [];
}
