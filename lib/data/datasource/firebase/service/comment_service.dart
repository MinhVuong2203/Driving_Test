import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driving_test_prep/data/datasource/firebase/service/post_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

// import '../../../../features/social_network/services/post_service.dart';

class CommentService {
  CommentService._();

  static final CommentService instance = CommentService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> getCommentsStream(String postId) {
    return _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .where('isDeleted', isEqualTo: false)
        .where('status', isEqualTo: true)
        .orderBy('createdAt', descending: false)
        .snapshots();
  }

  Future<void> addComment({
    required String postId,
    required String content,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Người dùng chưa đăng nhập.');

    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    final userData = userDoc.data();

    final String authorName =
    (userData?['displayName'] ?? user.displayName ?? 'Người dùng')
        .toString();

    final String authorAvatar =
    (userData?['photoURL'] ??
        userData?['authorAvatar'] ??
        user.photoURL ??
        '')
        .toString();

    final commentRef = _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc();

    await commentRef.set({
      'authorId': user.uid,
      'authorName': authorName,
      'authorAvatar': authorAvatar,
      'content': content.trim(),
      'likeCount': 0,
      'isDeleted': false,
      'status': true,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    await PostService.instance.increaseCommentCount(postId);
  }

  Future<void> softDeleteComment({
    required String postId,
    required String commentId,
  }) async {
    await _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .update({
      'isDeleted': true,
      'status': false,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    await PostService.instance.decreaseCommentCount(postId);
  }
}