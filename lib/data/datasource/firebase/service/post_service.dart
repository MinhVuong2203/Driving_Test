import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../features/social_network/models/post_model.dart';

class PostService {
  PostService._();

  static final PostService instance = PostService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _postsRef =>
      _firestore.collection('posts');

  Stream<List<PostModel>> getPostsStream() {
    return _postsRef
        .where('isDeleted', isEqualTo: false)
        .where('status', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map((doc) => PostModel.fromFirestore(doc))
          .toList(),
    );
  }

  Future<void> createPost({
    required String content,
    String imageUrl = '',
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Người dùng chưa đăng nhập.');
    }

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

    await _postsRef.add({
      'authorId': user.uid,
      'authorName': authorName,
      'authorAvatar': authorAvatar,
      'content': content.trim(),
      'imageUrl': imageUrl.trim(),
      'likeCount': 0,
      'commentCount': 0,
      'isDeleted': false,
      'status': true,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> softDeletePost(String postId) async {
    await _postsRef.doc(postId).update({
      'isDeleted': true,
      'status': false,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> likePost(String postId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Người dùng chưa đăng nhập.');

    final likeRef = _postsRef.doc(postId).collection('likes').doc(user.uid);
    final likeSnap = await likeRef.get();

    if (likeSnap.exists) return;

    final batch = _firestore.batch();
    batch.set(likeRef, {
      'userId': user.uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
    batch.update(_postsRef.doc(postId), {
      'likeCount': FieldValue.increment(1),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  Future<void> unlikePost(String postId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Người dùng chưa đăng nhập.');

    final likeRef = _postsRef.doc(postId).collection('likes').doc(user.uid);
    final likeSnap = await likeRef.get();

    if (!likeSnap.exists) return;

    final batch = _firestore.batch();
    batch.delete(likeRef);
    batch.update(_postsRef.doc(postId), {
      'likeCount': FieldValue.increment(-1),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  Future<bool> isPostLiked(String postId) async {
    final user = _auth.currentUser;
    if (user == null) return false;

    final likeSnap =
    await _postsRef.doc(postId).collection('likes').doc(user.uid).get();

    return likeSnap.exists;
  }

  Stream<bool> isPostLikedStream(String postId) {
    final user = _auth.currentUser;
    if (user == null) return Stream<bool>.value(false);

    return _postsRef
        .doc(postId)
        .collection('likes')
        .doc(user.uid)
        .snapshots()
        .map((doc) => doc.exists);
  }

  Future<void> toggleLike(String postId) async {
    final liked = await isPostLiked(postId);
    if (liked) {
      await unlikePost(postId);
    } else {
      await likePost(postId);
    }
  }

  Future<void> increaseCommentCount(String postId) async {
    await _postsRef.doc(postId).update({
      'commentCount': FieldValue.increment(1),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> decreaseCommentCount(String postId) async {
    await _postsRef.doc(postId).update({
      'commentCount': FieldValue.increment(-1),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<int> likeCountStream(String postId) {
    return _postsRef
        .doc(postId)
        .collection('likes')
        .snapshots()
        .map((snapshot) => snapshot.size);
  }

  Stream<int> commentCountStream(String postId) {
    return _postsRef
        .doc(postId)
        .collection('comments')
        .snapshots()
        .map((snapshot) => snapshot.size);
  }

}