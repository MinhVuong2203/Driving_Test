import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/post_model.dart';
import 'social_colors.dart';

class PostCard extends StatelessWidget {
  final PostModel post;
  final bool isLiked;
  final bool isAdmin;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onDelete;

  const PostCard({
    super.key,
    required this.post,
    required this.isLiked,
    required this.isAdmin,
    required this.onLike,
    required this.onComment,
    required this.onDelete,
  });

  String _timeAgo(DateTime? time) {
    if (time == null) return 'Vừa xong';

    final diff = DateTime.now().difference(time);

    if (diff.inMinutes < 1) return 'Vừa xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    if (diff.inDays < 7) return '${diff.inDays} ngày trước';
    return '${time.day}/${time.month}/${time.year}';
  }

  Stream<int> _likeCountStream(String postId) {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .snapshots()
        .map((snapshot) => snapshot.size);
  }

  Stream<int> _commentCountStream(String postId) {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .where('isDeleted', isEqualTo: false)
        .where('status', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.size);
  }

  void _showMoreMenu(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: kWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              if (isAdmin)
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: kError),
                  title: const Text(
                    'Xóa bài viết',
                    style: TextStyle(
                      color: kError,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    onDelete();
                  },
                ),
              if (!isAdmin)
                const ListTile(
                  leading: Icon(Icons.report_gmailerrorred_outlined),
                  title: Text('Báo cáo bài viết'),
                ),
              if (!isAdmin)
                const ListTile(
                  leading: Icon(Icons.bookmark_border_rounded),
                  title: Text('Lưu bài viết'),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(18),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: kNavy.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 22,
                backgroundColor: kAmberLight,
                backgroundImage:
                post.authorAvatar.isNotEmpty ? NetworkImage(post.authorAvatar) : null,
                child: post.authorAvatar.isEmpty
                    ? const Icon(Icons.person, color: kNavy)
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      post.authorName,
                      style: const TextStyle(
                        color: kNavy,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _timeAgo(post.createdAt),
                      style: const TextStyle(
                        color: kGrey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _showMoreMenu(context),
                icon: const Icon(Icons.more_horiz_rounded, color: kGrey),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            post.content,
            style: const TextStyle(
              color: kNavy,
              fontSize: 14,
              height: 1.6,
            ),
          ),
          if (post.imageUrl.isNotEmpty) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: 16 / 10,
                child: Image.network(
                  post.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return Container(
                      color: Colors.black12,
                      alignment: Alignment.center,
                      child: const Icon(Icons.broken_image_outlined, size: 40),
                    );
                  },
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),

          // Realtime stats
          Row(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: kAmber,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite,
                      size: 12,
                      color: kWhite,
                    ),
                  ),
                  const SizedBox(width: 6),
                  StreamBuilder<int>(
                    stream: _likeCountStream(post.postId),
                    builder: (context, snapshot) {
                      final likeCount = snapshot.data ?? post.likeCount;
                      return Text(
                        '$likeCount lượt thích',
                        style: const TextStyle(
                          color: kGrey,
                          fontSize: 13,
                        ),
                      );
                    },
                  ),
                ],
              ),
              const Spacer(),
              StreamBuilder<int>(
                stream: _commentCountStream(post.postId),
                builder: (context, snapshot) {
                  final commentCount = snapshot.data ?? post.commentCount;
                  return Text(
                    '$commentCount bình luận',
                    style: const TextStyle(
                      color: kGrey,
                      fontSize: 13,
                    ),
                  );
                },
              ),
            ],
          ),

          const Divider(height: 24),
          Row(
            children: <Widget>[
              Expanded(
                child: TextButton.icon(
                  onPressed: onLike,
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? kAmber : kGrey,
                  ),
                  label: Text(
                    'Thích',
                    style: TextStyle(
                      color: isLiked ? kAmber : kNavy,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: TextButton.icon(
                  onPressed: onComment,
                  icon: const Icon(Icons.mode_comment_outlined, color: kGrey),
                  label: const Text(
                    'Bình luận',
                    style: TextStyle(
                      color: kNavy,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
