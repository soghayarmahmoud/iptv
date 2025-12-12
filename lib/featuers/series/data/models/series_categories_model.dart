class SeriesCategoriesModel {
  final bool success;
  final List<SeriesCategory> categories;

  SeriesCategoriesModel({
    required this.success,
    required this.categories,
  });

  factory SeriesCategoriesModel.fromJson(Map<String, dynamic> json) {
    return SeriesCategoriesModel(
      success: json['success'] ?? false,
      categories: (json['categories'] as List<dynamic>?)
          ?.map((category) => SeriesCategory.fromJson(category))
          .toList() ?? [],
    );
  }
  

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'categories': categories.map((category) => category.toJson()).toList(),
    };
  }
}

class SeriesCategory {
  final String id;
  final String name;
  final int parentId;

  SeriesCategory({
    required this.id,
    required this.name,
    required this.parentId,
  });

  factory SeriesCategory.fromJson(Map<String, dynamic> json) {
    return SeriesCategory(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      parentId: json['parentId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'parentId': parentId,
    };
  }

  @override
  String toString() {
    return 'SeriesCategory(id: $id, name: $name, parentId: $parentId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SeriesCategory &&
        other.id == id &&
        other.name == name &&
        other.parentId == parentId;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ parentId.hashCode;
  }
}
