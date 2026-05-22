import '../../features/social_network/models/comment_model.dart';
import '../services/firebase/comment_api_service.dart';

class CommentApiRepository {
  CommentApiRepository._(this._service);

  final CommentApiService _service;

  static CommentApiRepository instance(String baseUrl) {
    return CommentApiRepository._(
      CommentApiService(baseUrl),
    );
  }

  Future<List<CommentModel>> getComments(String postId) {
    return _service.getComments(postId);
  }

  Future<CommentModel> addComment({
    required String postId,
    required String authorId,
    required String authorName,
    required String authorAvatar,
    required String content,
  }) {
    return _service.addComment(
      postId: postId,
      authorId: authorId,
      authorName: authorName,
      authorAvatar: authorAvatar,
      content: content,
    );
  }

  Future<void> deleteComment({
    required String postId,
    required String commentId,
    required String currentUserId,
    required bool isAdmin,
  }) {
    return _service.deleteComment(
      postId: postId,
      commentId: commentId,
      currentUserId: currentUserId,
      isAdmin: isAdmin,
    );
  }
}