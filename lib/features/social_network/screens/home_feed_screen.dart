import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driving_test_prep/shared/utils/constants/app_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/repository/notification_api_repository.dart';
import '../../../data/repository/post_api_repository.dart';
import '../../../data/repository/comment_api_repository.dart';
import '../../../data/services/firebase/notification_api_service.dart';
import '../models/comment_model.dart';
import '../controller/signout.dart';
import '../models/notification_model.dart';
import '../models/post_model.dart';
import '../widgets/comment_bottom_sheet.dart';
import '../widgets/create_post_box.dart';
import '../widgets/post_card.dart';
import '../widgets/social_colors.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  final String BACKEND_URL = AppConfig.baseUrl;

  late final PostApiRepository _postApiRepo =
  PostApiRepository.instance(BACKEND_URL);

  late final CommentApiRepository _commentApiRepo =
  CommentApiRepository.instance(BACKEND_URL);

  late final NotificationApiRepository _notificationApiRepo =
  NotificationApiRepository.instance(BACKEND_URL);

  bool _isAdmin = false;

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
    _loadCurrentUserRole();
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

  Future<void> _loadCurrentUserRole() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final data = snap.data();

    if (!mounted) return;

    setState(() {
      _isAdmin = data?['role']?.toString().toLowerCase() == 'admin';
    });
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

  Future<String> _getCurrentAddress() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return '';

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return '';
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isEmpty) return '';

    final p = placemarks.first;

    return [
      p.street,
      p.subLocality,
      p.locality,
      p.subAdministrativeArea,
      p.administrativeArea,
      p.country,
    ].where((e) => e != null && e.trim().isNotEmpty).join(', ');
  }

  Future<void> _showCreatePostDialog() async {
    final contentController = TextEditingController();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final dialogBg = isDark ? const Color(0xFF111827) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF111827);
    final subTextColor = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF6B7280);
    final inputBg = isDark ? const Color(0xFF1F2937) : const Color(0xFFF3F4F6);
    final borderColor = isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB);

    XFile? selectedImage;
    bool isPosting = false;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: dialogBg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              title: Text(
                'Tạo bài viết',
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        controller: contentController,
                        maxLines: 4,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 15,
                        ),
                        cursorColor: kAmber,
                        decoration: InputDecoration(
                          hintText: 'Bạn đang nghĩ gì?',
                          hintStyle: TextStyle(
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF9CA3AF),
                          ),
                          filled: true,
                          fillColor: inputBg,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: borderColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: borderColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: kAmber, width: 1.4),
                          ),
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
                        style: OutlinedButton.styleFrom(
                          foregroundColor: isDark ? Colors.white : kNavy,
                          side: BorderSide(color: borderColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
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
                  onPressed: isPosting ? null : () => Navigator.pop(dialogContext),
                  child: Text(
                    'Hủy',
                    style: TextStyle(color: subTextColor),
                  ),
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

                      final address = await _getCurrentAddress();

                      final postId = DateTime.now()
                          .microsecondsSinceEpoch
                          .toString();

                      final createdPost = await _postApiRepo.createPost(
                        postId: postId,
                        authorId: author.authorId,
                        authorName: author.authorName,
                        authorAvatar: author.authorAvatar,
                        content: content,
                        imageUrl: imageUrl,
                        address: address,
                      );

                      if (!mounted) return;

                      Navigator.pop(dialogContext);

                      setState(() {
                        _posts.insert(0, createdPost);
                        _localLikeCounts[createdPost.postId] = createdPost.likeCount;
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Đăng bài thành công')),
                      );

                      Future.delayed(const Duration(seconds: 4), () async {
                        if (!mounted) return;

                        try {
                          final checkedPost = await _postApiRepo.getPostById(createdPost.postId);

                          if (checkedPost.isDeleted || !checkedPost.status) {
                            setState(() {
                              _posts.removeWhere((p) => p.postId == createdPost.postId);
                              _localLikeCounts.remove(createdPost.postId);
                              _likedPostIds.remove(createdPost.postId);
                            });

                            if (!mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Bài viết vi phạm tiêu chuẩn nên đã bị tự động xóa'),
                              ),
                            );
                          }
                        } catch (e) {
                          debugPrint('Check moderation failed: $e');
                        }
                      });
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
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: kWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return CommentBottomSheet(
          post: post,
          commentApiRepo: _commentApiRepo,
          isAdmin: _isAdmin,
          onCommentAdded: () {
            if (!mounted) return;

            setState(() {
              final index = _posts.indexWhere(
                    (p) => p.postId == post.postId,
              );

              if (index != -1) {
                final oldPost = _posts[index];

                _posts[index] = oldPost.copyWith(
                  commentCount: oldPost.commentCount + 1,
                );
              }
            });
          },
        );
      },
    );
  }

  Future<void> _deletePost(PostModel post) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    final canDelete =
        _isAdmin || (currentUserId != null && post.authorId == currentUserId);

    if (!canDelete) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bạn không có quyền xóa bài viết này')),
      );
      return;
    }

    await _postApiRepo.deletePost(post.postId);

    if (!mounted) return;

    setState(() {
      _posts.removeWhere((item) => item.postId == post.postId);
      _likedPostIds.remove(post.postId);
      _localLikeCounts.remove(post.postId);
      _likingPostIds.remove(post.postId);
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
          userId: user.uid,
        );
      } else {
        await _postApiRepo.likePost(
          postId: post.postId,
          userId: user.uid,
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

  Future<void> _showNotifications() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return FutureBuilder<List<NotificationModel>>(
          future: _notificationApiRepo.getUserNotifications(user.uid),
          builder: (context, snapshot) {
            final isDark = Theme.of(context).brightness == Brightness.dark;

            final bg = isDark ? const Color(0xFF111827) : Colors.white;
            final cardBg = isDark ? const Color(0xFF1F2937) : const Color(0xFFF8FAFC);
            final textColor = isDark ? Colors.white : const Color(0xFF111827);
            final subColor = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF6B7280);
            final borderColor = isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB);

            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 42,
                      height: 5,
                      decoration: BoxDecoration(
                        color: subColor.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Thông báo',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (snapshot.connectionState == ConnectionState.waiting)
                    const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (snapshot.hasError)
                    Expanded(
                      child: Center(
                        child: Text(
                          'Không thể tải thông báo',
                          style: TextStyle(color: subColor),
                        ),
                      ),
                    )
                  else if ((snapshot.data ?? []).isEmpty)
                      Expanded(
                        child: Center(
                          child: Text(
                            'Chưa có thông báo nào',
                            style: TextStyle(color: subColor),
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: ListView.separated(
                          itemCount: snapshot.data!.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final item = snapshot.data![index];

                            return InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () async {
                                await _notificationApiRepo.markAsRead(
                                  item.notificationId,
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: item.isRead
                                      ? cardBg
                                      : const Color(0xFF2563EB).withValues(alpha: 0.16),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: borderColor),
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: item.isRead
                                          ? const Color(0xFF64748B)
                                          : const Color(0xFFF59E0B),
                                      child: const Icon(
                                        Icons.notifications,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.title,
                                            style: TextStyle(
                                              color: textColor,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            item.message,
                                            style: TextStyle(
                                              color: subColor,
                                              fontSize: 13,
                                              height: 1.35,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final feedBg = isDark ? const Color(0xFF0F172A) : kFeedBg;
    final cardBg = isDark ? const Color(0xFF111827) : kWhite;
    final textColor = isDark ? Colors.white : kNavy;
    final subTextColor = isDark ? const Color(0xFFCBD5E1) : kGrey;

    return Scaffold(
      backgroundColor: feedBg,
      appBar: AppBar(
        backgroundColor: cardBg,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Bảng tin',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: _showNotifications,
            icon: Icon(
              Icons.notifications_none_rounded,
              color: textColor,
            ),
          ),
          IconButton(
            onPressed: _isSigningOut ? null : _handleSignOut,
            icon: Icon(
              Icons.person_outline_rounded,
              color: textColor,
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
              backgroundColor: cardBg,
              textColor: textColor,
              subTextColor: subTextColor,
              inputColor: isDark ? const Color(0xFF1F2937) : const Color(0xFFF1F5F9),
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

                final currentUserId = FirebaseAuth.instance.currentUser?.uid;
                final canDelete =
                    _isAdmin || (currentUserId != null && post.authorId == currentUserId);

                return PostCard(
                  post: post.copyWith(likeCount: currentLikeCount),
                  isLiked: _likedPostIds.contains(post.postId),
                  isAdmin: _isAdmin,
                  canDelete: canDelete,
                  onLike: () => _toggleLike(post),
                  onComment: () => _showCommentDialog(post),
                  onDelete: () => _deletePost(post),
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