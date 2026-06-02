class TrafficViolation {
  final String id;
  final String title;
  final List<String> vehicleTypes;
  final String subjectText;
  final String penaltyText;
  final String penaltyLegalBasis;
  final String additionalPenaltyText;
  final String additionalPenaltyLegalBasis;
  final int fineMin;
  final int fineMax;
  final List<String> aliases;
  final List<String> keywords;
  final String searchText;
  final List<String> relatedViolationIds;
  final String status;

  TrafficViolation({
    required this.id,
    required this.title,
    required this.vehicleTypes,
    required this.subjectText,
    required this.penaltyText,
    required this.penaltyLegalBasis,
    required this.additionalPenaltyText,
    required this.additionalPenaltyLegalBasis,
    required this.fineMin,
    required this.fineMax,
    this.aliases = const [],
    this.keywords = const [],
    this.searchText = '',
    required this.relatedViolationIds,
    this.status = 'active',
  });

  factory TrafficViolation.fromJson(Map<String, dynamic> json) {
    return TrafficViolation(
      id: _readString(json, 'id'),
      title: _readString(json, 'title'),
      vehicleTypes: _readStringList(json, 'vehicle_types', 'vehicleTypes'),
      subjectText: _readString(json, 'subject_text', 'subjectText'),
      penaltyText: _readString(json, 'penalty_text', 'penaltyText'),
      penaltyLegalBasis:
          _readString(json, 'penalty_legal_basis', 'penaltyLegalBasis'),
      additionalPenaltyText:
          _readString(json, 'additional_penalty_text', 'additionalPenaltyText'),
      additionalPenaltyLegalBasis: _readString(
        json,
        'additional_penalty_legal_basis',
        'additionalPenaltyLegalBasis',
      ),
      fineMin: _readInt(json, 'fine_min', 'fineMin'),
      fineMax: _readInt(json, 'fine_max', 'fineMax'),
      aliases: _readStringList(json, 'aliases'),
      keywords: _readStringList(json, 'keywords'),
      searchText: _readString(json, 'search_text', 'searchText'),
      relatedViolationIds: _readStringList(
        json,
        'related_violation_ids',
        'relatedViolationIds',
      ),
      status: _readString(json, 'status').isEmpty
          ? 'active'
          : _readString(json, 'status'),
    );
  }

  String get fineRangeText {
    if (penaltyText.trim().isNotEmpty) return penaltyText;
    if (fineMin <= 0 && fineMax <= 0) return '';
    if (fineMax <= 0 || fineMin == fineMax) {
      return 'Phạt tiền ${_formatMoney(fineMin)} đồng';
    }
    return 'Phạt tiền từ ${_formatMoney(fineMin)} đồng đến ${_formatMoney(fineMax)} đồng';
  }

  bool get hasAdditionalPenalty =>
      additionalPenaltyText.trim().isNotEmpty ||
      additionalPenaltyLegalBasis.trim().isNotEmpty;

  String get vehicleLabel {
    final labels = vehicleTypes.map((type) {
      switch (type) {
        case 'motorbike':
          return 'Xe máy';
        case 'car':
          return 'Ô tô';
        case 'bicycle':
          return 'Xe đạp';
        case 'pedestrian':
          return 'Người đi bộ';
        case 'passenger':
          return 'Hành khách';
        case 'vehicle_owner':
          return 'Chủ xe';
        case 'specialized_vehicle':
          return 'Xe chuyên dùng';
        case 'animal_drawn_vehicle':
          return 'Xe thô sơ';
        default:
          return 'Khác';
      }
    }).toSet();

    return labels.join(', ');
  }

  static String _readString(
    Map<String, dynamic> json,
    String key, [
    String? fallbackKey,
  ]) {
    final value = json[key] ?? (fallbackKey == null ? null : json[fallbackKey]);
    return value?.toString() ?? '';
  }

  static int _readInt(
    Map<String, dynamic> json,
    String key, [
    String? fallbackKey,
  ]) {
    final value = json[key] ?? (fallbackKey == null ? null : json[fallbackKey]);
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static List<String> _readStringList(
    Map<String, dynamic> json,
    String key, [
    String? fallbackKey,
  ]) {
    final value = json[key] ?? (fallbackKey == null ? null : json[fallbackKey]);
    if (value is List) {
      return value.map((item) => item.toString()).toList();
    }
    return [];
  }

  static String _formatMoney(int value) {
    return value.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]}.',
        );
  }
}

class TrafficViolationSearchResult {
  final String message;
  final int total;
  final List<TrafficViolation> data;

  TrafficViolationSearchResult({
    required this.message,
    required this.total,
    required this.data,
  });

  factory TrafficViolationSearchResult.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    final items = rawData is List
        ? rawData
            .map((item) => TrafficViolation.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ))
            .toList()
        : <TrafficViolation>[];

    return TrafficViolationSearchResult(
      message: json['message']?.toString() ?? '',
      total: TrafficViolation._readInt(json, 'total'),
      data: items,
    );
  }
}
