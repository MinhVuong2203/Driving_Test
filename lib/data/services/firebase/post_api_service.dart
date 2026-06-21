import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:driving_test_prep/features/social_network/models/post_model.dart';
import 'auth_api_headers.dart';
import 'package:driving_test_prep/features/social_network/models/video_upload_result.dart';

class PostApiService {
  PostApiService(this.baseUrl);
  final String baseUrl;

  Future<List<PostModel>> fetchPosts() async {
    final res = await http.get(
      Uri.parse('$baseUrl/api/Post'),
      headers: await AuthApiHeaders.bearer(),
    );
    if (res.statusCode != 200) throw Exception('Failed to load posts');
    final list = jsonDecode(res.body) as List;
    return list.map((e) => PostModel.fromJson(e)).toList();
  }

  Future<PostModel> getPostById(String postId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/api/Post/$postId'),
      headers: await AuthApiHeaders.bearer(),
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to get post: ${res.statusCode} - ${res.body}');
    }

    return PostModel.fromJson(
      jsonDecode(res.body) as Map<String, dynamic>,
    );
  }

  Future<List<PostModel>> getPostsByAuthor(String authorId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/api/Post/author/$authorId'),
      headers: await AuthApiHeaders.bearer(),
    );
    if (res.statusCode != 200) throw Exception('Failed to load author posts');
    final list = jsonDecode(res.body) as List;
    return list.map((e) => PostModel.fromJson(e)).toList();
  }

  Future<PostModel> createPost({
    required String content,
    String imageUrl = '',
    String videoUrl = '',
    String videoPublicId = '',
    double videoDuration = 0,
    int videoBytes = 0,
    required String postId,
    required String authorId,
    required String authorName,
    required String authorAvatar,
    required String address,
  }) async {
    final nowUtc = DateTime.now().toUtc().toIso8601String();

    final res = await http.post(
      Uri.parse('$baseUrl/api/Post'),
      headers: await AuthApiHeaders.json(),
      body: jsonEncode({
        'postId': postId,
        'authorId': authorId,
        'authorName': authorName,
        'authorAvatar': authorAvatar,
        'content': content,
        'imageUrl': imageUrl,
        'videoUrl': videoUrl,
        'videoPublicId': videoPublicId,
        'videoDuration': videoDuration,
        'videoBytes': videoBytes,
        'createdAt': nowUtc,
        'updatedAt': nowUtc,
        'address': address,
      }),
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      String message = res.body;

      try {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        message = data['message']?.toString() ?? res.body;
      } catch (_) {}

      throw Exception(message);
    }

    return PostModel.fromJson(
      jsonDecode(res.body) as Map<String, dynamic>,
    );
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
      headers: await AuthApiHeaders.json(),
      body: jsonEncode(body),
    );
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Failed to update post');
    }
  }

  Future<void> deletePost(String postId) async {
    final res = await http.delete(
      Uri.parse('$baseUrl/api/Post/$postId'),
      headers: await AuthApiHeaders.bearer(),
    );
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
      headers: await AuthApiHeaders.bearer(),
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
      headers: await AuthApiHeaders.bearer(),
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
      headers: await AuthApiHeaders.bearer(),
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to check liked');
    }

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return data['isLiked'] == true;
  }

  Future<String> uploadPostImage(File file) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/api/Post/upload-image'),
    );

    request.files.add(
      await http.MultipartFile.fromPath('file', file.path),
    );
    request.headers.addAll(await AuthApiHeaders.bearer());

    final response = await request.send();
    final body = await response.stream.bytesToString();

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Upload image failed: $body');
    }

    final data = jsonDecode(body) as Map<String, dynamic>;
    return data['imageUrl'].toString();
  }

  Future<List<PostModel>> fetchPostsPaged({
    int limit = 10,
    DateTime? lastCreatedAt,
  }) async {
    final queryParams = <String, String>{
      'limit': limit.toString(),
    };

    if (lastCreatedAt != null) {
      queryParams['lastCreatedAt'] = lastCreatedAt.toUtc().toIso8601String();
    }

    final uri = Uri.parse('$baseUrl/api/Post/paged').replace(
      queryParameters: queryParams,
    );

    final res = await http.get(
      uri,
      headers: await AuthApiHeaders.bearer(),
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to load posts: ${res.body}');
    }

    debugPrint('PAGED POSTS RAW: ${res.body}');

    final List data = jsonDecode(res.body) as List;

    return data
        .map((e) => PostModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<VideoUploadResult> uploadPostVideo(File file) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/api/Post/upload-video'),
    );

    request.headers.addAll(
      await AuthApiHeaders.bearer(),
    );

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        file.path,
        filename: file.uri.pathSegments.last,
      ),
    );

    final streamedResponse = await request.send();
    final responseBody = await streamedResponse.stream.bytesToString();

    if (streamedResponse.statusCode < 200 ||
        streamedResponse.statusCode >= 300) {
      String message = responseBody;

      try {
        final data = jsonDecode(responseBody) as Map<String, dynamic>;
        message = data['message']?.toString() ?? responseBody;
      } catch (_) {}

      throw Exception(message);
    }

    final data = jsonDecode(responseBody) as Map<String, dynamic>;

    return VideoUploadResult.fromJson(data);
  }

  Future<void> deleteUploadedVideo(String publicId) async {
    if (publicId.trim().isEmpty) return;

    final response = await http.delete(
      Uri.parse('$baseUrl/api/Post/video'),
      headers: await AuthApiHeaders.json(),
      body: jsonEncode({
        'publicId': publicId,
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Không thể xóa video: ${response.statusCode} - ${response.body}',
      );
    }
  }

}
