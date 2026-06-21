import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String postId;
  final String authorId;
  final String authorName;
  final String authorAvatar;
  final String content;
  final String imageUrl;
  final int likeCount;
  final int commentCount;
  final bool isDeleted;
  final bool status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? address;
  final bool authorIsVip;
  final String authorVipName;
  final String videoUrl;
  final String videoPublicId;
  final double videoDuration;
  final int videoBytes;

  const PostModel({
    required this.postId,
    required this.authorId,
    required this.authorName,
    required this.authorAvatar,
    required this.content,
    required this.imageUrl,
    required this.likeCount,
    required this.commentCount,
    required this.isDeleted,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.address,
    required this.authorIsVip,
    required this.authorVipName,
    required this.videoUrl,
    required this.videoPublicId,
    required this.videoDuration,
    required this.videoBytes,
  });

  factory PostModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc,
      ) {
    final data = doc.data() ?? <String, dynamic>{};

    return PostModel(
      postId: doc.id,
      authorId: (data['authorId'] ?? '').toString(),
      authorName: (data['authorName'] ?? '').toString(),
      authorAvatar: (data['authorAvatar'] ?? '').toString(),
      content: (data['content'] ?? '').toString(),
      imageUrl: (data['imageUrl'] ?? '').toString(),
      likeCount: (data['likeCount'] ?? 0) is int
          ? data['likeCount'] as int
          : int.tryParse('${data['likeCount']}') ?? 0,
      commentCount: (data['commentCount'] ?? 0) is int
          ? data['commentCount'] as int
          : int.tryParse('${data['commentCount']}') ?? 0,
      isDeleted: data['isDeleted'] == true,
      status: data['status'] == true,
      createdAt: _toDateTime(data['createdAt']),
      updatedAt: _toDateTime(data['updatedAt']),
      address: (data['address'] ?? '').toString(),
      authorIsVip: data['authorIsVip'] == true,
      authorVipName: (data['authorVipName'] ?? '').toString(),
      videoUrl: (data['videoUrl'] ?? '').toString(),
      videoPublicId: (data['videoPublicId'] ?? '').toString(),
      videoDuration: _toDouble(data['videoDuration']),
      videoBytes: _toInt(data['videoBytes']),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'authorId': authorId,
      'authorName': authorName,
      'authorAvatar': authorAvatar,
      'content': content,
      'imageUrl': imageUrl,
      'likeCount': likeCount,
      'commentCount': commentCount,
      'isDeleted': isDeleted,
      'status': status,
      'createdAt': createdAt == null ? null : Timestamp.fromDate(createdAt!),
      'updatedAt': updatedAt == null ? null : Timestamp.fromDate(updatedAt!),
      'address': address,
      'authorIsVip': authorIsVip,
      'authorVipName': authorVipName,
      'videoUrl': videoUrl,
      'videoPublicId': videoPublicId,
      'videoDuration': videoDuration,
      'videoBytes': videoBytes,
    };
  }

  PostModel copyWith({
    String? postId,
    String? authorId,
    String? authorName,
    String? authorAvatar,
    String? content,
    String? imageUrl,
    int? likeCount,
    int? commentCount,
    bool? isDeleted,
    bool? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? address,
    bool? authorIsVip,
    String? authorVipName,
    String? videoUrl,
    String? videoPublicId,
    double? videoDuration,
    int? videoBytes,
  }) {
    return PostModel(
      postId: postId ?? this.postId,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      isDeleted: isDeleted ?? this.isDeleted,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      address: address ?? this.address,
      authorIsVip: authorIsVip ?? this.authorIsVip,
      authorVipName: authorVipName ?? this.authorVipName,
      videoUrl: videoUrl ?? this.videoUrl,
      videoPublicId: videoPublicId ?? this.videoPublicId,
      videoDuration: videoDuration ?? this.videoDuration,
      videoBytes: videoBytes ?? this.videoBytes,
    );
  }

  static DateTime? _toDateTime(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    return null;
  }

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      postId: json['postId']?.toString() ?? json['id']?.toString() ?? '',
      authorId: json['authorId']?.toString() ?? '',
      authorName: json['authorName']?.toString() ?? '',
      authorAvatar: json['authorAvatar']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      likeCount: json['likeCount'] is int
          ? json['likeCount']
          : int.tryParse('${json['likeCount']}') ?? 0,
      commentCount: json['commentCount'] is int
          ? json['commentCount']
          : int.tryParse('${json['commentCount']}') ?? 0,
      isDeleted: json['isDeleted'] == true,
      status: json['status'] == true,
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
      address: json['address']?.toString() ?? '',
      authorIsVip: json['authorIsVip'] == true ||
          json['authorIsVip']?.toString().toLowerCase() == 'true',
      authorVipName: json['authorVipName']?.toString() ?? '',
      videoUrl: json['videoUrl']?.toString() ?? '',
      videoPublicId: json['videoPublicId']?.toString() ?? '',
      videoDuration: _toDouble(json['videoDuration']),
      videoBytes: _toInt(json['videoBytes']),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is String) return DateTime.tryParse(value);
    if (value is int) {
      // nếu backend trả epoch millis
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    return null;
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

}