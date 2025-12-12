// Dart models for the user data response with JSON (de)serialization.

// Root model that contains the access token and customer payload
class UserDataModel {
  final String accessToken;
  final Customer customer;

  const UserDataModel({required this.accessToken, required this.customer});

  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    return UserDataModel(
      accessToken: json['access_token'] as String? ?? json['accessToken'] as String? ?? '',
      customer: Customer.fromJson(json['customer'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'access_token': accessToken,
      'customer': customer.toJson(),
    };
  }
}

enum CreditType { oneYear, sixMonths, threeMonths, oneMonth, unknown }

CreditType _creditTypeFromString(String? value) {
  switch (value) {
    case 'ONE_YEAR':
      return CreditType.oneYear;
    case 'SIX_MONTHS':
      return CreditType.sixMonths;
    case 'THREE_MONTHS':
      return CreditType.threeMonths;
    case 'ONE_MONTH':
      return CreditType.oneMonth;
    default:
      return CreditType.unknown;
  }
}

String _creditTypeToString(CreditType value) {
  switch (value) {
    case CreditType.oneYear:
      return 'ONE_YEAR';
    case CreditType.sixMonths:
      return 'SIX_MONTHS';
    case CreditType.threeMonths:
      return 'THREE_MONTHS';
    case CreditType.oneMonth:
      return 'ONE_MONTH';
    case CreditType.unknown:
      return 'UNKNOWN';
  }
}

enum CustomerStatus { active, inactive, suspended, unknown }

CustomerStatus _statusFromString(String? value) {
  switch (value) {
    case 'ACTIVE':
      return CustomerStatus.active;
    case 'INACTIVE':
      return CustomerStatus.inactive;
    case 'SUSPENDED':
      return CustomerStatus.suspended;
    default:
      return CustomerStatus.unknown;
  }
}

String _statusToString(CustomerStatus value) {
  switch (value) {
    case CustomerStatus.active:
      return 'ACTIVE';
    case CustomerStatus.inactive:
      return 'INACTIVE';
    case CustomerStatus.suspended:
      return 'SUSPENDED';
    case CustomerStatus.unknown:
      return 'UNKNOWN';
  }
}

class Customer {
  final String id;
  final String? customerKey;
  final String? macAddress;
  final String username;
  final CreditType creditType;
  final CustomerStatus status;
  final DateTime? endDate;
  final List<Playlist> playlists;
  final Reseller? reseller;
  final String type;

  const Customer({
    required this.id,
    required this.customerKey,
    required this.macAddress,
    required this.username,
    required this.creditType,
    required this.status,
    required this.endDate,
    required this.playlists,
    required this.reseller,
    required this.type,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    final playlistsJson = json['playlists'] as List<dynamic>?;
    return Customer(
      id: json['id'] as String? ?? '',
      customerKey: json['customerKey'] as String?,
      macAddress: json['macAddress'] as String?,
      username: json['username'] as String? ?? '',
      creditType: _creditTypeFromString(json['creditType'] as String?),
      status: _statusFromString(json['status'] as String?),
      endDate: (json['endDate'] as String?) != null ? DateTime.tryParse(json['endDate'] as String) : null,
      playlists: playlistsJson == null
          ? const <Playlist>[]
          : playlistsJson
              .whereType<Map<String, dynamic>>()
              .map((e) => Playlist.fromJson(e))
              .toList(),
      reseller: json['reseller'] == null ? null : Reseller.fromJson(json['reseller'] as Map<String, dynamic>),
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'customerKey': customerKey,
      'macAddress': macAddress,
      'username': username,
      'creditType': _creditTypeToString(creditType),
      'status': _statusToString(status),
      'endDate': endDate?.toIso8601String(),
      'playlists': playlists.map((e) => e.toJson()).toList(),
      'reseller': reseller?.toJson(),
      'type': type,
    };
  }
}

class Playlist {
  final String id;
  final String name;
  final String customerId;
  final String url;
  final String type;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Playlist({
    required this.id,
    required this.name,
    required this.customerId,
    required this.url,
    required this.type,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      customerId: json['customerId'] as String? ?? '',
      url: json['url'] as String? ?? '',
      type: json['type'] as String? ?? '',
      isActive: (json['isActive'] as bool?) ?? false,
      createdAt: (json['createdAt'] as String?) != null ? DateTime.tryParse(json['createdAt'] as String) : null,
      updatedAt: (json['updatedAt'] as String?) != null ? DateTime.tryParse(json['updatedAt'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'customerId': customerId,
      'url': url,
      'type': type,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class Reseller {
  final String id;
  final String name;
  final String email;
  final String? companyName;

  const Reseller({
    required this.id,
    required this.name,
    required this.email,
    required this.companyName,
  });

  factory Reseller.fromJson(Map<String, dynamic> json) {
    return Reseller(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      companyName: json['companyName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'companyName': companyName,
    };
  }
}


