import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../controller/signout.dart';
import '../models/post_model.dart';
import '../services/comment_service.dart';
import '../services/post_service.dart';
import '../widgets/create_post_box.dart';
import '../widgets/post_card.dart';
import '../widgets/social_colors.dart';
import 'email_login_screen.dart';

class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  final PostService _postService = PostService.instance;
  final CommentService _commentService = CommentService.instance;

  final bool _isAdmin = true;

  Future<void> _showCreatePostDialog() async {
    final TextEditingController contentController = TextEditingController();
    final TextEditingController imageController = TextEditingController();

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

                await _postService.createPost(
                  content: content,
                  imageUrl: imageUrl,
                );

                if (!mounted) return;
                Navigator.pop(context);
              },
              child: const Text('Đăng'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showCommentDialog(PostModel post) async {
    final TextEditingController commentController = TextEditingController();

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
                    stream: _commentService.getCommentsStream(post.postId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text('Chưa có bình luận nào'),
                        );
                      }

                      final docs = snapshot.data!.docs;

                      return ListView.builder(
                        itemCount: docs.length,
                        itemBuilder: (_, index) {
                          final data = docs[index].data();
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              backgroundImage: (data['authorAvatar'] ?? '')
                                  .toString()
                                  .isNotEmpty
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
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            subtitle: Text((data['content'] ?? '').toString()),
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

                        await _commentService.addComment(
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
    await _postService.softDeletePost(postId);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã xóa bài viết')),
    );
  }

  bool _isSigningOut = false;

  Future<void> _handleSignOut() async {
    await SignOutController.signOut(
      context: context,
      setSigningOut: (bool value) {
        if (mounted) setState(() => _isSigningOut = value);
      },
      isMounted: () => mounted,
    );

    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const EmailLoginScreen()),
          (route) => false,
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
          style: TextStyle(
            color: kNavy,
            fontWeight: FontWeight.w800,
          ),
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
      body: StreamBuilder<List<PostModel>>(
        stream: _postService.getPostsStream(),
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

          return ListView(
            children: <Widget>[
              CreatePostBox(
                currentUserName: 'Bình Minh',
                currentUserAvatar: '',
                onCreatePost: _showCreatePostDialog,
              ),
              if (posts.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(
                    child: Text(
                      'Chưa có bài đăng nào',
                      style: TextStyle(
                        color: kGrey,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ...posts.map(
                    (post) => StreamBuilder<bool>(
                  stream: _postService.isPostLikedStream(post.postId),
                  builder: (context, likedSnapshot) {
                    final isLiked = likedSnapshot.data ?? false;

                    return PostCard(
                      post: post,
                      isLiked: isLiked,
                      isAdmin: _isAdmin,
                      onLike: () => _postService.toggleLike(post.postId),
                      onComment: () => _showCommentDialog(post),
                      onDelete: () => _deletePost(post.postId),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }
}