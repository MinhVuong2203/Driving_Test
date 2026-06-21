import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/post_model.dart';
import 'social_colors.dart';
import 'post_video_player.dart';

class PostCard extends StatelessWidget {
  final PostModel post;
  final bool isLiked;
  final bool isAdmin;
  final bool canDelete;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onDelete;

  const PostCard({
    super.key,
    required this.post,
    required this.isLiked,
    required this.isAdmin,
    required this.canDelete,
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
              if (canDelete)
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: kError),
                  title: Text(
                    isAdmin ? 'Xóa bài viết với quyền admin' : 'Xóa bài viết',
                    style: const TextStyle(
                      color: kError,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    onDelete();
                  },
                )
              else ...[
                const ListTile(
                  leading: Icon(Icons.report_gmailerrorred_outlined),
                  title: Text('Báo cáo bài viết'),
                ),
                const ListTile(
                  leading: Icon(Icons.bookmark_border_rounded),
                  title: Text('Lưu bài viết'),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  bool _isValidUrl(String url) {
    if (url.trim().isEmpty) return false;
    if (url == 'string') return false;

    final uri = Uri.tryParse(url);
    return uri != null && uri.hasScheme && uri.hasAuthority;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardBg = isDark ? const Color(0xFF111827) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subTextColor = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF94A3B8);
    final borderColor = isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB);
    // final actionBg = isDark ? const Color(0xFF1F2937) : Colors.white;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.25)
                : kNavy.withOpacity(0.05),
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
                // backgroundImage:
                // post.authorAvatar.isNotEmpty ? NetworkImage(post.authorAvatar) : null,
                // child: post.authorAvatar.isEmpty
                //     ? const Icon(Icons.person, color: kNavy)
                //     : null,
                backgroundImage: _isValidUrl(post.authorAvatar)
                    ? NetworkImage(post.authorAvatar)
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            post.authorName,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (post.authorIsVip) ...[
                          const SizedBox(width: 5),
                          const Icon(
                            Icons.verified,
                            color: Color(0xFF1877F2),
                            size: 18,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _timeAgo(post.createdAt),
                      style: TextStyle(
                        color: subTextColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (canDelete)
                IconButton(
                  onPressed: () => _showMoreMenu(context),
                  icon: Icon(
                    Icons.more_horiz_rounded,
                    color: subTextColor,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            post.content,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              height: 1.6,
            ),
          ),
          if (_isValidUrl(post.imageUrl)) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                height: 200,
                width: double.infinity,
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

          if (_isValidUrl(post.videoUrl)) ...[
            const SizedBox(height: 12),
            PostVideoPlayer(
              videoUrl: post.videoUrl,
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
                  Text(
                    '${post.likeCount} lượt thích',
                    style: TextStyle(
                      color: subTextColor,
                      fontSize: 13,
                    ),
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
                    style: TextStyle(
                      color: subTextColor,
                      fontSize: 13,
                    ),
                  );
                },
              ),
            ],
          ),

          Divider(
            height: 24,
            color: borderColor,
          ),
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
                      color: isLiked ? kAmber : textColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: TextButton.icon(
                  onPressed: onComment,
                  icon: Icon(
                    Icons.mode_comment_outlined,
                    color: subTextColor,
                  ),
                  label: Text(
                    'Bình luận',
                    style: TextStyle(
                      color: textColor,
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
