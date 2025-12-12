// Series detail + episodes response models

class SeriesDetailResponse {
  final bool success;
  final SeriesDetail series;

  const SeriesDetailResponse({
    required this.success,
    required this.series,
  });

  factory SeriesDetailResponse.fromJson(Map<String, dynamic> json) {
    return SeriesDetailResponse(
      success: (json['success'] as bool?) ?? false,
      series: SeriesDetail.fromJson(
        (json['series'] as Map<String, dynamic>? ?? <String, dynamic>{}),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'success': success,
      'series': series.toJson(),
    };
  }
}

class SeriesDetail {
  final List<Season> seasons;
  final SeriesInfo info;
  final Map<String, List<Episode>> episodesBySeason;

  const SeriesDetail({
    required this.seasons,
    required this.info,
    required this.episodesBySeason,
  });

  factory SeriesDetail.fromJson(Map<String, dynamic> json) {
    final seasonsJson = json['seasons'] as List<dynamic>?;
    final episodesJson = json['episodes'];

    return SeriesDetail(
      seasons: seasonsJson == null
          ? const <Season>[]
          : seasonsJson
              .whereType<Map<String, dynamic>>()
              .map(Season.fromJson)
              .toList(),
      info: SeriesInfo.fromJson(
        (json['info'] as Map<String, dynamic>? ?? <String, dynamic>{}),
      ),
      episodesBySeason: _parseEpisodesMap(episodesJson),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'seasons': seasons.map((e) => e.toJson()).toList(),
      'info': info.toJson(),
      'episodes': episodesBySeason.map(
        (season, eps) => MapEntry(season, eps.map((e) => e.toJson()).toList()),
      ),
    };
  }
}

class SeriesInfo {
  final String name;
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

  const SeriesInfo({
    required this.name,
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

  factory SeriesInfo.fromJson(Map<String, dynamic> json) {
    return SeriesInfo(
      name: _asString(json['name']),
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
      'name': name,
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
}

class Season {
  final int? seasonNumber;
  final String? name;

  const Season({
    this.seasonNumber,
    this.name,
  });

  factory Season.fromJson(Map<String, dynamic> json) {
    // The provided sample shows an empty seasons array; keep fields optional and flexible
    return Season(
      seasonNumber: _asNullableInt(json['season_number'] ?? json['season'] ?? json['num']),
      name: _asNullableString(json['name']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'season_number': seasonNumber,
      'name': name,
    };
  }
}

class Episode {
  final String id;
  final int episodeNum;
  final String title;
  final String containerExtension;
  final EpisodeInfo info;
  final String customSid;
  final String added;
  final int season;
  final String directSource;

  const Episode({
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

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: _asString(json['id']),
      episodeNum: _asInt(json['episode_num']),
      title: _asString(json['title']),
      containerExtension: _asString(json['container_extension']),
      info: EpisodeInfo.fromJson(
        (json['info'] as Map<String, dynamic>? ?? <String, dynamic>{}),
      ),
      customSid: _asString(json['custom_sid']),
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

class EpisodeInfo {
  final String name;
  final String coverBig;

  const EpisodeInfo({
    required this.name,
    required this.coverBig,
  });

  factory EpisodeInfo.fromJson(Map<String, dynamic> json) {
    return EpisodeInfo(
      name: _asString(json['name']),
      coverBig: _asString(json['cover_big']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'cover_big': coverBig,
    };
  }
}


Map<String, List<Episode>> _parseEpisodesMap(dynamic json) {
  if (json == null) return <String, List<Episode>>{};
  
  // Handle case where episodes is a List<dynamic>
  if (json is List) {
    final episodes = json
        .whereType<Map<String, dynamic>>()
        .map(Episode.fromJson)
        .toList();
    return {'default': episodes};
  }
  
  // Handle case where episodes is a Map<String, dynamic>
  if (json is Map<String, dynamic>) {
    final Map<String, List<Episode>> result = <String, List<Episode>>{};
    json.forEach((key, value) {
      if (value is List) {
        final episodes = value
            .whereType<Map<String, dynamic>>()
            .map(Episode.fromJson)
            .toList();
        result[key] = episodes;
      }
    });
    return result;
  }
  
  return <String, List<Episode>>{};
}

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

int? _asNullableInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

double _asDouble(dynamic value) {
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) {
    final parsed = double.tryParse(value);
    if (parsed != null) return parsed;
  }
  return 0.0;
}

List<String> _asStringList(dynamic value) {
  if (value is List) {
    return value.map((e) => _asString(e)).toList();
  }
  return const <String>[];
}


