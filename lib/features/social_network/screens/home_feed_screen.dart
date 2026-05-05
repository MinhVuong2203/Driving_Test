import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driving_test_prep/shared/utils/constants/app_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/repository/comment_repository.dart';
import '../../../data/repository/post_api_repository.dart';
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
  final String BACKEND_URL = AppConfig.baseUrl;

  late final PostApiRepository _postApiRepo =
  PostApiRepository.instance(BACKEND_URL);

  final CommentRepository _commentRepo = CommentRepository.instance;

  final bool _isAdmin = true;

  final ScrollController _scrollController = ScrollController();

  final List<PostModel> _posts = <PostModel>[];

  final Set<String> _likedPostIds = <String>{};
  final Map<String, int> _localLikeCounts = <String, int>{};
  final Set<String> _likingPostIds = <String>{};

  final int _pageSize = 10;

  bool _isInitialLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  bool _isSigningOut = false;

  @override
  void initState() {
    super.initState();

    _loadInitialPosts();

    _scrollController.addListener(() {
      if (!_scrollController.hasClients) return;

      final position = _scrollController.position;

      if (position.pixels >= position.maxScrollExtent - 300) {
        _loadMorePosts();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialPosts() async {
    setState(() {
      _isInitialLoading = true;
      _hasMore = true;
    });

    try {
      final posts = await _postApiRepo.fetchPostsPaged(
        limit: _pageSize,
      );

      _likedPostIds.clear();
      _localLikeCounts.clear();

      await _loadLikeStatus(posts);

      if (!mounted) return;

      setState(() {
        _posts
          ..clear()
          ..addAll(posts);

        _hasMore = posts.length == _pageSize;
        _isInitialLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isInitialLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi tải bài viết: $e')),
      );
    }
  }

  Future<void> _loadMorePosts() async {
    if (_isLoadingMore || !_hasMore || _posts.isEmpty) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final lastCreatedAt = _posts.last.createdAt;

      final newPosts = await _postApiRepo.fetchPostsPaged(
        limit: _pageSize,
        lastCreatedAt: lastCreatedAt,
      );

      await _loadLikeStatus(newPosts);

      if (!mounted) return;

      setState(() {
        _posts.addAll(newPosts);
        _hasMore = newPosts.length == _pageSize;
        _isLoadingMore = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoadingMore = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi tải thêm bài viết: $e')),
      );
    }
  }

  Future<void> _loadLikeStatus(List<PostModel> posts) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    for (final post in posts) {
      final liked = await _postApiRepo.isLiked(
        postId: post.postId,
        userId: user.uid,
      );

      if (liked) {
        _likedPostIds.add(post.postId);
      }
    }
  }

  Future<void> _refreshPosts() async {
    await _loadInitialPosts();
  }

  Future<({String authorId, String authorName, String authorAvatar})>
  _getAuthorInfo() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('Người dùng chưa đăng nhập');
    }

    const defaultAvatar =
        'https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y';

    return (
    authorId: user.uid,
    authorName: user.displayName ?? user.email ?? 'Người dùng',
    authorAvatar: user.photoURL ?? defaultAvatar,
    );
  }

  Future<void> _showCreatePostDialog() async {
    final contentController = TextEditingController();
    XFile? selectedImage;
    bool isPosting = false;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Tạo bài viết'),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                      if (selectedImage != null)
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: 180,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(selectedImage!.path),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: isPosting
                            ? null
                            : () async {
                          final picker = ImagePicker();

                          final image = await picker.pickImage(
                            source: ImageSource.gallery,
                            imageQuality: 80,
                          );

                          if (image != null) {
                            setDialogState(() {
                              selectedImage = image;
                            });
                          }
                        },
                        icon: const Icon(Icons.image_outlined),
                        label: const Text('Chọn ảnh từ thư viện'),
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed:
                  isPosting ? null : () => Navigator.pop(dialogContext),
                  child: const Text('Hủy'),
                ),
                ElevatedButton(
                  onPressed: isPosting
                      ? null
                      : () async {
                    final content = contentController.text.trim();

                    if (content.isEmpty && selectedImage == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Vui lòng nhập nội dung hoặc chọn ảnh',
                          ),
                        ),
                      );
                      return;
                    }

                    setDialogState(() {
                      isPosting = true;
                    });

                    try {
                      String imageUrl = '';

                      if (selectedImage != null) {
                        imageUrl = await _postApiRepo.uploadPostImage(
                          File(selectedImage!.path),
                        );
                      }

                      final author = await _getAuthorInfo();

                      final postId = DateTime.now()
                          .microsecondsSinceEpoch
                          .toString();

                      await _postApiRepo.createPost(
                        postId: postId,
                        authorId: author.authorId,
                        authorName: author.authorName,
                        authorAvatar: author.authorAvatar,
                        content: content,
                        imageUrl: imageUrl,
                      );

                      final newPost = PostModel(
                        postId: postId,
                        authorId: author.authorId,
                        authorName: author.authorName,
                        authorAvatar: author.authorAvatar,
                        content: content,
                        imageUrl: imageUrl,
                        likeCount: 0,
                        commentCount: 0,
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                        status: true,
                        isDeleted: false,
                      );

                      if (!mounted) return;

                      Navigator.pop(dialogContext);

                      setState(() {
                        _posts.insert(0, newPost);
                        _localLikeCounts[postId] = 0;
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Đăng bài thành công'),
                        ),
                      );
                    } catch (e) {
                      setDialogState(() {
                        isPosting = false;
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Lỗi đăng bài: $e')),
                      );
                    }
                  },
                  child: isPosting
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Text('Đăng'),
                ),
              ],
            );
          },
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
                              style:
                              const TextStyle(fontWeight: FontWeight.w700),
                            ),
                            subtitle: Text(
                              (data['content'] ?? '').toString(),
                            ),
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

    setState(() {
      _posts.removeWhere((post) => post.postId == postId);
      _likedPostIds.remove(postId);
      _localLikeCounts.remove(postId);
      _likingPostIds.remove(postId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã xóa bài viết')),
    );
  }


  Future<void> _toggleLike(PostModel post) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bạn cần đăng nhập để thích bài viết')),
      );
      return;
    }

    if (_likingPostIds.contains(post.postId)) return;

    final wasLiked = _likedPostIds.contains(post.postId);
    final oldCount = _localLikeCounts[post.postId] ?? post.likeCount;
    final newCount = wasLiked ? oldCount - 1 : oldCount + 1;

    setState(() {
      _likingPostIds.add(post.postId);

      if (wasLiked) {
        _likedPostIds.remove(post.postId);
      } else {
        _likedPostIds.add(post.postId);
      }

      _localLikeCounts[post.postId] = newCount < 0 ? 0 : newCount;
    });

    try {
      if (wasLiked) {
        await _postApiRepo.unlikePost(
          postId: post.postId,
          userId: user!.uid,
        );
      } else {
        await _postApiRepo.likePost(
          postId: post.postId,
          userId: user!.uid,
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        if (wasLiked) {
          _likedPostIds.add(post.postId);
        } else {
          _likedPostIds.remove(post.postId);
        }

        _localLikeCounts[post.postId] = oldCount;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi cập nhật like: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _likingPostIds.remove(post.postId);
        });
      }
    }
  }

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
    final user = FirebaseAuth.instance.currentUser;
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
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: kNavy,
            ),
          ),
          IconButton(
            onPressed: _isSigningOut ? null : _handleSignOut,
            icon: const Icon(
              Icons.person_outline_rounded,
              color: kNavy,
            ),
          ),
        ],
      ),
      body: _isInitialLoading
          ? const Center(
        child: CircularProgressIndicator(color: kAmber),
      )
          : RefreshIndicator(
        onRefresh: _refreshPosts,
        child: ListView(
          controller: _scrollController,
          children: <Widget>[
            CreatePostBox(
              currentUserName: user?.displayName ?? user?.email ?? 'Người dùng',
              currentUserAvatar: user?.photoURL ?? '',
              onCreatePost: _showCreatePostDialog,
            ),
            if (_posts.isEmpty)
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
            ..._posts.map(
                  (post) {
                final currentLikeCount =
                    _localLikeCounts[post.postId] ?? post.likeCount;

                return PostCard(
                  post: post.copyWith(likeCount: currentLikeCount),
                  isLiked: _likedPostIds.contains(post.postId),
                  isAdmin: _isAdmin,
                  onLike: () => _toggleLike(post),
                  onComment: () => _showCommentDialog(post),
                  onDelete: () => _deletePost(post.postId),
                );
              },
            ),
            if (_isLoadingMore)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: CircularProgressIndicator(color: kAmber),
                ),
              ),
            if (!_hasMore && _posts.isNotEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    'Đã tải hết bài viết',
                    style: TextStyle(color: kGrey),
                  ),
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}