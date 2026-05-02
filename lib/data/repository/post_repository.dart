
import 'package:driving_test_prep/data/services/firebase/post_service.dart';
import 'package:driving_test_prep/features/social_network/models/post_model.dart';

class PostRepository {
  PostRepository._(this._postService);

  static final PostRepository instance = PostRepository._(PostService.instance);

  final PostService _postService;

  Stream<List<PostModel>> getPostsStream() => _postService.getPostsStream();

  Future<void> createPost({
    required String content,
    String imageUrl = '',
  }) {
    return _postService.createPost(content: content, imageUrl: imageUrl);
  }

  Future<void> softDeletePost(String postId) => _postService.softDeletePost(postId);

  Future<void> toggleLike(String postId) => _postService.toggleLike(postId);

  Stream<bool> isPostLikedStream(String postId) => _postService.isPostLikedStream(postId);

  Stream<int> likeCountStream(String postId) => _postService.likeCountStream(postId);

  Stream<int> commentCountStream(String postId) => _postService.commentCountStream(postId);
}
