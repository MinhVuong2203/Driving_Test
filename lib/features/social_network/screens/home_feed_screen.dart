import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driving_test_prep/shared/utils/constants/app_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:driving_test_prep/data/repository/post_api_repository.dart';
import '../../../data/repository/comment_repository.dart';
import '../controller/signout.dart';
import '../models/post_model.dart';
import '../widgets/create_post_box.dart';
import '../widgets/post_card.dart';
import '../widgets/social_colors.dart';

class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  String BACKEND_URL = AppConfig.baseUrl;
  late final PostApiRepository _postApiRepo = PostApiRepository.instance(BACKEND_URL);
  final CommentRepository _commentRepo = CommentRepository.instance;

  final bool _isAdmin = true;

  late Future<List<PostModel>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = _postApiRepo.fetchPosts();
  }

  Future<void> _refreshPosts() async {
    setState(() {
      _postsFuture = _postApiRepo.fetchPosts();
    });
  }

  Future<({String authorId, String authorName, String authorAvatar})>
  _getAuthorInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Người dùng chưa đăng nhập');
    }

    final snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final data = snap.data();

    final authorName =
    (data?['displayName'] ?? user.displayName ?? 'Người dùng').toString();

    // nếu backend bắt buộc authorAvatar không rỗng => dùng default
    final authorAvatar = (data?['photoURL'] ?? user.photoURL ?? '').toString();
    const defaultAvatar =
        'https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y';

    return (
    authorId: user.uid,
    authorName: authorName,
    authorAvatar: authorAvatar.isEmpty ? defaultAvatar : authorAvatar,
    );
  }

  Future<void> _showCreatePostDialog() async {
    final contentController = TextEditingController();
    final imageController = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Tạo bài viết'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: contentController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Bạn đang nghĩ gì?',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: imageController,
                  decoration: const InputDecoration(
                    hintText: 'Link ảnh (không bắt buộc)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                final content = contentController.text.trim();
                final imageUrl = imageController.text.trim();
                if (content.isEmpty) return;

                final author = await _getAuthorInfo();
                final postId =
                DateTime.now().microsecondsSinceEpoch.toString();

                await _postApiRepo.createPost(
                  postId: postId,
                  authorId: author.authorId,
                  authorName: author.authorName,
                  authorAvatar: author.authorAvatar,
                  content: content,
                  imageUrl: imageUrl,
                );

                if (!mounted) return;
                Navigator.pop(context);
                await _refreshPosts();
              },
              child: const Text('Đăng'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showCommentDialog(PostModel post) async {
    final commentController = TextEditingController();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: kWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: SizedBox(
            height: 420,
            child: Column(
              children: <Widget>[
                const Text(
                  'Bình luận',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: kNavy,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: _commentRepo.getCommentsStream(post.postId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text('Chưa có bình luận nào'));
                      }

                      final docs = snapshot.data!.docs;

                      return ListView.builder(
                        itemCount: docs.length,
                        itemBuilder: (_, index) {
                          final data = docs[index].data();
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              backgroundImage:
                              (data['authorAvatar'] ?? '').toString().isNotEmpty
                                  ? NetworkImage(
                                (data['authorAvatar'] ?? '').toString(),
                              )
                                  : null,
                              child: (data['authorAvatar'] ?? '')
                                  .toString()
                                  .isEmpty
                                  ? const Icon(Icons.person)
                                  : null,
                            ),
                            title: Text(
                              (data['authorName'] ?? '').toString(),
                              style:
                              const TextStyle(fontWeight: FontWeight.w700),
                            ),
                            subtitle:
                            Text((data['content'] ?? '').toString()),
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: commentController,
                        decoration: InputDecoration(
                          hintText: 'Viết bình luận...',
                          filled: true,
                          fillColor: kInputBg,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () async {
                        final text = commentController.text.trim();
                        if (text.isEmpty) return;

                        await _commentRepo.addComment(
                          postId: post.postId,
                          content: text,
                        );

                        commentController.clear();
                      },
                      icon: const Icon(Icons.send_rounded, color: kAmber),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _deletePost(String postId) async {
    await _postApiRepo.deletePost(postId);

    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Đã xóa bài viết')));
    await _refreshPosts();
  }

  bool _isSigningOut = false;

  Future<void> _handleSignOut() async {
    await SignOutController.signOut(
      context: context,
      setSigningOut: (value) {
        if (mounted) setState(() => _isSigningOut = value);
      },
      isMounted: () => mounted,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kFeedBg,
      appBar: AppBar(
        backgroundColor: kWhite,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Bảng tin',
          style: TextStyle(color: kNavy, fontWeight: FontWeight.w800),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded, color: kNavy),
          ),
          IconButton(
            onPressed: _isSigningOut ? null : _handleSignOut,
            icon: const Icon(Icons.person_outline_rounded, color: kNavy),
          ),
        ],
      ),
      body: FutureBuilder<List<PostModel>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: kAmber),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Lỗi tải bài đăng: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final posts = snapshot.data ?? <PostModel>[];

          return RefreshIndicator(
            onRefresh: _refreshPosts,
            child: ListView(
              children: <Widget>[
                CreatePostBox(
                  currentUserName: 'Bình Minh', // có thể lấy từ user luôn
                  currentUserAvatar: '',
                  onCreatePost: _showCreatePostDialog,
                ),
                if (posts.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        'Chưa có bài đăng nào',
                        style: TextStyle(color: kGrey, fontSize: 15),
                      ),
                    ),
                  ),
                ...posts.map(
                      (post) => PostCard(
                    post: post,
                    isLiked: false,
                    isAdmin: _isAdmin,
                    onLike: () async => _refreshPosts(),
                    onComment: () => _showCommentDialog(post),
                    onDelete: () => _deletePost(post.postId),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
