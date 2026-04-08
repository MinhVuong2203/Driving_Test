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
    );
  }

  static DateTime? _toDateTime(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    return null;
  }
}