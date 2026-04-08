import 'package:flutter/material.dart';
import 'social_colors.dart';

class PostStats extends StatelessWidget {
  final int likeCount;
  final int commentCount;

  const PostStats({
    super.key,
    required this.likeCount,
    required this.commentCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
              '$likeCount lượt thích',
              style: const TextStyle(
                color: kGrey,
                fontSize: 13,
              ),
            ),
          ],
        ),
        const Spacer(),
        Text(
          '$commentCount bình luận',
          style: const TextStyle(
            color: kGrey,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}