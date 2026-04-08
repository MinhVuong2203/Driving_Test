import 'package:flutter/material.dart';
import '../models/post_model.dart';
import 'social_colors.dart';

class PostHeader extends StatelessWidget {
  final PostModel post;
  final bool isAdmin;
  final VoidCallback? onMorePressed;

  const PostHeader({
    super.key,
    required this.post,
    required this.isAdmin,
    this.onMorePressed,
  });

  String _timeAgo(DateTime? time) {
    if (time == null) return 'Vừa xong';

    final Duration diff = DateTime.now().difference(time);

    if (diff.inMinutes < 1) return 'Vừa xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    if (diff.inDays < 7) return '${diff.inDays} ngày trước';
    return '${time.day}/${time.month}/${time.year}';
  }


  @override
  Widget build(BuildContext context) {
    return Row(
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
          onPressed: onMorePressed,
          icon: const Icon(Icons.more_horiz_rounded, color: kGrey),
          tooltip: isAdmin ? 'Tùy chọn quản trị' : 'Tùy chọn',
        ),
      ],
    );
  }
}