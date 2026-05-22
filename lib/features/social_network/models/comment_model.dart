class CommentModel {
  final String commentId;
  final String postId;
  final String authorId;
  final String authorName;
  final String authorAvatar;
  final String content;
  final int likeCount;
  final bool isDeleted;
  final bool status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CommentModel({
    required this.commentId,
    required this.postId,
    required this.authorId,
    required this.authorName,
    required this.authorAvatar,
    required this.content,
    required this.likeCount,
    required this.isDeleted,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      commentId: json['commentId']?.toString() ?? '',
      postId: json['postId']?.toString() ?? '',
      authorId: json['authorId']?.toString() ?? '',
      authorName: json['authorName']?.toString() ?? '',
      authorAvatar: json['authorAvatar']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      likeCount: json['likeCount'] is int
          ? json['likeCount']
          : int.tryParse('${json['likeCount']}') ?? 0,
      isDeleted: json['isDeleted'] == true,
      status: json['status'] == true,
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}