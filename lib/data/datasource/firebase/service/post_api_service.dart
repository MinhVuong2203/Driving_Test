import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:driving_test_prep/features/social_network/models/post_model.dart';

class PostApiService {
  PostApiService(this.baseUrl);
  final String baseUrl;

  Future<List<PostModel>> fetchPosts() async {
    final res = await http.get(Uri.parse('$baseUrl/api/Post'));
    if (res.statusCode != 200) throw Exception('Failed to load posts');
    final list = jsonDecode(res.body) as List;
    return list.map((e) => PostModel.fromJson(e)).toList();
  }

  Future<PostModel> getPostById(String id) async {
    final res = await http.get(Uri.parse('$baseUrl/api/Post/$id'));
    if (res.statusCode != 200) throw Exception('Failed to load post');
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return PostModel.fromJson(data);
  }

  Future<List<PostModel>> getPostsByAuthor(String authorId) async {
    final res = await http.get(Uri.parse('$baseUrl/api/Post/author/$authorId'));
    if (res.statusCode != 200) throw Exception('Failed to load author posts');
    final list = jsonDecode(res.body) as List;
    return list.map((e) => PostModel.fromJson(e)).toList();
  }

  Future<void> createPost({
    required String content,
    String imageUrl = '',
    required String postId,
    required String authorId,
    required String authorName,
    required String authorAvatar,
  }) async {
    final nowUtc = DateTime.now().toUtc().toIso8601String();

    final res = await http.post(
      Uri.parse('$baseUrl/api/Post'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'postId': postId,
        'authorId': authorId,
        'authorName': authorName,
        'authorAvatar': authorAvatar,
        'content': content,
        'imageUrl': imageUrl,

        // thêm 2 field thời gian dạng UTC
        'createdAt': nowUtc,
        'updatedAt': nowUtc,
      }),
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Failed to create post: ${res.statusCode} - ${res.body}');
    }
  }




  Future<void> updatePost(
      String id, {
        String? content,
        String? imageUrl,
        bool? status,
        bool? isDeleted,
      }) async {
    final body = <String, dynamic>{
      if (content != null) 'content': content,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (status != null) 'status': status,
      if (isDeleted != null) 'isDeleted': isDeleted,
    };

    final res = await http.put(
      Uri.parse('$baseUrl/api/Post/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Failed to update post');
    }
  }

  Future<void> deletePost(String postId) async {
    final res = await http.delete(Uri.parse('$baseUrl/api/Post/$postId'));
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Failed to delete post');
    }
  }

  Future<void> likePost({
    required String postId,
    required String userId,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/Post/$postId/like?userId=$userId'),
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Failed to like post: ${res.statusCode} - ${res.body}');
    }
  }

  Future<void> unlikePost({
    required String postId,
    required String userId,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/Post/$postId/unlike?userId=$userId'),
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Failed to unlike post: ${res.statusCode} - ${res.body}');
    }
  }

  Future<bool> isLiked({
    required String postId,
    required String userId,
  }) async {
    final res = await http.get(
      Uri.parse('$baseUrl/api/Post/$postId/liked?userId=$userId'),
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to check liked');
    }

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return data['isLiked'] == true;
  }
}
