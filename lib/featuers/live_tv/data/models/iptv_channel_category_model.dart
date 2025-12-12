// Models for IPTV categories response

class IptvCategoriesResponse {
  final bool success;
  final List<IptvCategory> categories;

  const IptvCategoriesResponse({required this.success, required this.categories});

  factory IptvCategoriesResponse.fromJson(Map<String, dynamic> json) {
    final categoriesJson = json['categories'] as List<dynamic>?;
    return IptvCategoriesResponse(
      success: (json['success'] as bool?) ?? false,
      categories: categoriesJson == null
          ? const <IptvCategory>[]
          : categoriesJson
              .whereType<Map<String, dynamic>>()
              .map(IptvCategory.fromJson)
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'success': success,
      'categories': categories.map((e) => e.toJson()).toList(),
    };
  }
}

class IptvCategory {
  final String id;
  final String name;
  final int parentId;

  const IptvCategory({required this.id, required this.name, required this.parentId});

  factory IptvCategory.fromJson(Map<String, dynamic> json) {
    return IptvCategory(
      id: _asString(json['id']),
      name: (json['name'] as String?)?.trim() ?? '',
      parentId: _asInt(json['parentId']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'parentId': parentId,
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
  return 0;
}


