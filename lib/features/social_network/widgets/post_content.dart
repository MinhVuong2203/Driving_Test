import 'package:flutter/material.dart';
import 'social_colors.dart';

class PostContent extends StatefulWidget {
  final String content;

  const PostContent({
    super.key,
    required this.content,
  });

  @override
  State<PostContent> createState() => _PostContentState();
}

class _PostContentState extends State<PostContent> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final bool isLong = widget.content.length > 120;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          widget.content,
          maxLines: _expanded ? null : 4,
          overflow: _expanded ? null : TextOverflow.ellipsis,
          style: const TextStyle(
            color: kNavy,
            fontSize: 14,
            height: 1.6,
          ),
        ),
        if (isLong) ...<Widget>[
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Text(
              _expanded ? 'Thu gọn' : 'Xem thêm',
              style: const TextStyle(
                color: kAmber,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ],
    );
  }
}