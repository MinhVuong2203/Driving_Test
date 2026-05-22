import 'package:cloud_firestore/cloud_firestore.dart';

class UserVipModel {
  final String vipId;
  final String name;
  final DateTime? startDate;
  final DateTime? endDate;

  const UserVipModel({
    required this.vipId,
    required this.name,
    this.startDate,
    this.endDate,
  });

  factory UserVipModel.fromMap(Map<String, dynamic> map) {
    return UserVipModel(
      vipId: map['vipId']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      startDate: _readDate(map['startDate']),
      endDate: _readDate(map['endDate']),
    );
  }

  bool get isActive {
    if (name.trim().isEmpty && vipId.trim().isEmpty) return false;
    final expiresAt = endDate;
    if (expiresAt == null) return true;
    return DateTime.now().isBefore(expiresAt);
  }

  String get durationLabel {
    final expiresAt = endDate;
    if (expiresAt == null) return 'Vĩnh viễn';
    return 'Hết hạn ${expiresAt.day}/${expiresAt.month}/${expiresAt.year}';
  }

  static DateTime? _readDate(Object? value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
