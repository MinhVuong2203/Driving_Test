import 'package:flutter/material.dart';
import 'social_colors.dart';

class PostActions extends StatelessWidget {
  final bool isLiked;
  final VoidCallback onLike;
  final VoidCallback onComment;

  const PostActions({
    super.key,
    required this.isLiked,
    required this.onLike,
    required this.onComment,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}