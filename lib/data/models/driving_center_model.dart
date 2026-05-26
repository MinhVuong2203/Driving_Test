class DrivingCenter {
  final String id;
  final String name;
  final String phoneNumber;
  final String photoUrl;
  final String website;
  final double rating;
  final int reviewCount;
  final String businessStatus;
  final String address;
  final String district;
  final String city;
  final String openingStatus;
  final String searchQuery;
  final String createdAt;
  final String updatedAt;

  DrivingCenter({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.photoUrl,
    required this.website,
    required this.rating,
    required this.reviewCount,
    required this.businessStatus,
    required this.address,
    required this.district,
    required this.city,
    required this.openingStatus,
    required this.searchQuery,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DrivingCenter.fromJson(Map<String, dynamic> json) {
    return DrivingCenter(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      photoUrl: json['photo_url'] ?? '',
      website: json['website'] ?? '',
      rating: _toDouble(json['rating']),
      reviewCount: _toInt(json['review_count']),
      businessStatus: json['business_status'] ?? '',
      address: json['address'] ?? '',
      district: json['district'] ?? '',
      city: json['city'] ?? '',
      openingStatus: json['opening_status'] ?? '',
      searchQuery: json['search_query'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  String get displayAddress {
    return [address, district, city]
        .where((item) => item.trim().isNotEmpty)
        .join(', ');
  }

  bool get hasPhoto => photoUrl.trim().isNotEmpty;

  bool get hasPhone => phoneNumber.trim().isNotEmpty;

  bool get hasWebsite => website.trim().isNotEmpty;
}

class DrivingCenterPage {
  final List<DrivingCenter> items;
  final int total;
  final int page;
  final int pageSize;
  final bool hasMore;

  DrivingCenterPage({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.hasMore,
  });

  factory DrivingCenterPage.fromJson(Map<String, dynamic> json) {
    final List data = json['data'] ?? [];
    final pageSize = DrivingCenter._toInt(json['page_size'] ?? json['pageSize']);
    final items = data
        .map((item) => DrivingCenter.fromJson(Map<String, dynamic>.from(item)))
        .toList();

    return DrivingCenterPage(
      items: items,
      total: DrivingCenter._toInt(json['total']),
      page: DrivingCenter._toInt(json['page']),
      pageSize: pageSize,
      hasMore: json['has_more'] == true ||
          json['hasMore'] == true ||
          (pageSize > 0 && items.length >= pageSize),
    );
  }
}
