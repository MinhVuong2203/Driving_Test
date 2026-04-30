import 'package:driving_test_prep/data/datasource/firebase/service/post_api_service.dart';
import 'package:driving_test_prep/features/social_network/models/post_model.dart';

class PostApiRepository {
  PostApiRepository._(this._postApiService);

  static PostApiRepository? _instance;

  static PostApiRepository instance(String baseUrl) {
    _instance ??= PostApiRepository._(PostApiService(baseUrl));
    return _instance!;
  }

  final PostApiService _postApiService;

  Future<List<PostModel>> fetchPosts() => _postApiService.fetchPosts();

  Future<void> createPost({
    required String postId,
    required String authorId,
    required String authorName,
    required String authorAvatar,
    required String content,
    String imageUrl = '',
  }) =>
      _postApiService.createPost(
        postId: postId,
        authorId: authorId,
        authorName: authorName,
        authorAvatar: authorAvatar,
        content: content,
        imageUrl: imageUrl,
      );



  Future<void> deletePost(String postId) => _postApiService.deletePost(postId);

  Future<PostModel> getPostById(String id) => _postApiService.getPostById(id);
  Future<List<PostModel>> getPostsByAuthor(String authorId) => _postApiService.getPostsByAuthor(authorId);
  Future<void> updatePost(
      String id, {
        String? content,
        String? imageUrl,
        bool? status,
        bool? isDeleted,
      }) =>
      _postApiService.updatePost(
        id,
        content: content,
        imageUrl: imageUrl,
        status: status,
        isDeleted: isDeleted,
      );

}
