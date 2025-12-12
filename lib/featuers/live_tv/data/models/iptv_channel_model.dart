// Models for IPTV channels response

class IptvChannelsResponse {
  final bool success;
  final List<IptvChannel> channels;
  final int totalChannels;
  final String categoryId;

  const IptvChannelsResponse({
    required this.success,
    required this.channels,
    required this.totalChannels,
    required this.categoryId,
  });

  factory IptvChannelsResponse.fromJson(Map<String, dynamic> json) {
    final channelsJson = json['channels'] as List<dynamic>?;
    return IptvChannelsResponse(
      success: _asBool(json['success']),
      channels: channelsJson == null
          ? const <IptvChannel>[]
          : channelsJson
              .whereType<Map<String, dynamic>>()
              .map(IptvChannel.fromJson)
              .toList(),
      totalChannels: _asInt(json['totalChannels']),
      categoryId: _asString(json['categoryId']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'success': success,
      'channels': channels.map((e) => e.toJson()).toList(),
      'totalChannels': totalChannels,
      'categoryId': categoryId,
    };
  }
}

class IptvChannel {
  final String id;
  final String name;
  final String streamType;
  final String icon; // may be empty string
  final String categoryId;
  final String added; // keep original string value
  final String streamUrl;
  final IptvChannelOriginalData originalData;

  const IptvChannel({
    required this.id,
    required this.name,
    required this.streamType,
    required this.icon,
    required this.categoryId,
    required this.added,
    required this.streamUrl,
    required this.originalData,
  });

  factory IptvChannel.fromJson(Map<String, dynamic> json) {
    return IptvChannel(
      id: _asString(json['id']),
      name: _asString(json['name']),
      streamType: _asString(json['streamType']),
      icon: _asString(json['icon']),
      categoryId: _asString(json['categoryId']),
      added: _asString(json['added']),
      streamUrl: _asString(json['streamUrl']),
      originalData: IptvChannelOriginalData.fromJson(
        (json['originalData'] as Map<String, dynamic>?) ?? const <String, dynamic>{},
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
      'streamUrl': streamUrl,
      'originalData': originalData.toJson(),
    };
  }
}

class IptvChannelOriginalData {
  final int num;
  final String name;
  final String streamType;
  final int streamId;
  final String streamIcon; // may be empty
  final String? epgChannelId; // can be null
  final String added;
  final String categoryId;
  final String customSid;
  final int tvArchive;
  final String directSource;
  final int tvArchiveDuration;

  const IptvChannelOriginalData({
    required this.num,
    required this.name,
    required this.streamType,
    required this.streamId,
    required this.streamIcon,
    required this.epgChannelId,
    required this.added,
    required this.categoryId,
    required this.customSid,
    required this.tvArchive,
    required this.directSource,
    required this.tvArchiveDuration,
  });

  factory IptvChannelOriginalData.fromJson(Map<String, dynamic> json) {
    return IptvChannelOriginalData(
      num: _asInt(json['num']),
      name: _asString(json['name']),
      streamType: _asString(json['stream_type']),
      streamId: _asInt(json['stream_id']),
      streamIcon: _asString(json['stream_icon']),
      epgChannelId: _asNullableString(json['epg_channel_id']),
      added: _asString(json['added']),
      categoryId: _asString(json['category_id']),
      customSid: _asString(json['custom_sid']),
      tvArchive: _asInt(json['tv_archive']),
      directSource: _asString(json['direct_source']),
      tvArchiveDuration: _asInt(json['tv_archive_duration']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'num': num,
      'name': name,
      'stream_type': streamType,
      'stream_id': streamId,
      'stream_icon': streamIcon,
      'epg_channel_id': epgChannelId,
      'added': added,
      'category_id': categoryId,
      'custom_sid': customSid,
      'tv_archive': tvArchive,
      'direct_source': directSource,
      'tv_archive_duration': tvArchiveDuration,
    };
  }
}

bool _asBool(dynamic value) {
  if (value is bool) return value;
  if (value is String) {
    final lower = value.toLowerCase();
    if (lower == 'true') return true;
    if (lower == 'false') return false;
  }
  if (value is num) return value != 0;
  return false;
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
  if (value is num) return value.toInt();
  if (value is String) {
    final parsed = int.tryParse(value);
    return parsed ?? 0;
  }
  return 0;
}


