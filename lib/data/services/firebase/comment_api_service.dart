import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../features/social_network/models/comment_model.dart';


class CommentApiService {
  CommentApiService(this.baseUrl);

  final String baseUrl;

  Future<List<CommentModel>> getComments(String postId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/api/Comment/$postId'),
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to load comments: ${res.body}');
    }

    final List data = jsonDecode(res.body) as List;

    return data
        .map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<CommentModel> addComment({
    required String postId,
    required String authorId,
    required String authorName,
    required String authorAvatar,
    required String content,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/Comment/$postId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'authorId': authorId,
        'authorName': authorName,
        'authorAvatar': authorAvatar,
        'content': content,
      }),
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Failed to add comment: ${res.body}');
    }

    return CommentModel.fromJson(
      jsonDecode(res.body) as Map<String, dynamic>,
    );
  }

  Future<void> deleteComment({
    required String postId,
    required String commentId,
    required String currentUserId,
    required bool isAdmin,
  }) async {
    final uri = Uri.parse('$baseUrl/api/Comment/$postId/$commentId').replace(
      queryParameters: {
        'currentUserId': currentUserId,
        'isAdmin': isAdmin.toString(),
      },
    );

    final res = await http.delete(uri);

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Failed to delete comment: ${res.body}');
    }
  }
}