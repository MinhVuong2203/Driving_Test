import 'package:flutter/material.dart';
import '../models/post_model.dart';
import 'social_colors.dart';
import 'package:flutter/foundation.dart';

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

    final diff = DateTime.now().difference(time);

    if (diff.inMinutes < 1) return 'Vừa xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    if (diff.inDays < 7) return '${diff.inDays} ngày trước';
    return '${time.day}/${time.month}/${time.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final textColor = isDark ? Colors.white : kNavy;
    final subTextColor = isDark ? const Color(0xFFCBD5E1) : kGrey;
    final avatarBg = isDark ? const Color(0xFF334155) : kAmberLight;

    debugPrint(
      'POST VIP: ${post.authorName} - ${post.authorIsVip} - ${post.authorVipName}',
    );
    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: 22,
          backgroundColor: avatarBg,
          backgroundImage: post.authorAvatar.isNotEmpty
              ? NetworkImage(post.authorAvatar)
              : null,
          child: post.authorAvatar.isEmpty
              ? Icon(Icons.person, color: textColor)
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
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        gradient: const LinearGradient(
                          colors: <Color>[
                            Color(0xFFF59E0B),
                            Color(0xFFFACC15),
                          ],
                        ),
                      ),
                      child: Text(
                        post.authorVipName.isNotEmpty
                            ? post.authorVipName
                            : 'VIP',
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
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
        IconButton(
          onPressed: onMorePressed,
          icon: Icon(Icons.more_horiz_rounded, color: subTextColor),
          tooltip: isAdmin ? 'Tùy chọn quản trị' : 'Tùy chọn',
        ),
      ],
    );
  }
}