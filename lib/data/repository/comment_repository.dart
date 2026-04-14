import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driving_test_prep/data/datasource/firebase/service/comment_service.dart';

class CommentRepository {
  CommentRepository._(this._commentService);

  static final CommentRepository instance =
  CommentRepository._(CommentService.instance);

  final CommentService _commentService;

  Stream<QuerySnapshot<Map<String, dynamic>>> getCommentsStream(String postId) {
    return _commentService.getCommentsStream(postId);
  }

  Future<void> addComment({
    required String postId,
    required String content,
  }) {
    return _commentService.addComment(postId: postId, content: content);
  }

  Future<void> softDeleteComment({
    required String postId,
    required String commentId,
  }) {
    return _commentService.softDeleteComment(postId: postId, commentId: commentId);
  }
}
