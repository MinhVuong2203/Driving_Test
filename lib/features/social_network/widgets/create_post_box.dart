import 'package:flutter/material.dart';
import 'social_colors.dart';

class CreatePostBox extends StatelessWidget {
  final String currentUserName;
  final String currentUserAvatar;
  final VoidCallback onCreatePost;

  const CreatePostBox({
    super.key,
    required this.currentUserName,
    required this.currentUserAvatar,
    required this.onCreatePost,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 8),
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
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 22,
                backgroundColor: kAmberLight,
                backgroundImage: currentUserAvatar.isNotEmpty
                    ? NetworkImage(currentUserAvatar)
                    : null,
                child: currentUserAvatar.isEmpty
                    ? const Icon(Icons.person, color: kNavy)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InkWell(
                  onTap: onCreatePost,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 13,
                    ),
                    decoration: BoxDecoration(
                      color: kInputBg,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      '$currentUserName ơi, bạn đang nghĩ gì?',
                      style: TextStyle(
                        color: kGrey.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                child: _QuickActionButton(
                  icon: Icons.edit_note_rounded,
                  label: 'Đăng bài',
                  onTap: onCreatePost,
                ),
              ),
              Expanded(
                child: _QuickActionButton(
                  icon: Icons.image_outlined,
                  label: 'Thêm ảnh',
                  onTap: onCreatePost,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: kAmber, size: 20),
      label: Text(
        label,
        style: const TextStyle(
          color: kNavy,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}