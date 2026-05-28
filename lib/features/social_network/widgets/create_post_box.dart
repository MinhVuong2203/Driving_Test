import 'package:flutter/material.dart';
import 'social_colors.dart';

class CreatePostBox extends StatelessWidget {
  final String currentUserName;
  final String currentUserAvatar;
  final VoidCallback onCreatePost;
  final Color backgroundColor;
  final Color textColor;
  final Color subTextColor;
  final Color inputColor;

  const CreatePostBox({
    super.key,
    required this.currentUserName,
    required this.currentUserAvatar,
    required this.onCreatePost,
    this.backgroundColor = Colors.white,
    this.textColor = const Color(0xFF0F172A),
    this.subTextColor = const Color(0xFF94A3B8),
    this.inputColor = const Color(0xFFF1F5F9),
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark
        ? const Color(0xFF374151)
        : const Color(0xFFE5E7EB);

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: backgroundColor,
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
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 22,
                backgroundColor:
                isDark ? const Color(0xFF334155) : kAmberLight,
                backgroundImage: currentUserAvatar.isNotEmpty
                    ? NetworkImage(currentUserAvatar)
                    : null,
                child: currentUserAvatar.isEmpty
                    ? Icon(Icons.person, color: textColor)
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
                      color: inputColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      '$currentUserName ơi, bạn đang nghĩ gì?',
                      style: TextStyle(
                        color: subTextColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(height: 1, color: borderColor),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                child: _QuickActionButton(
                  icon: Icons.edit_note_rounded,
                  label: 'Đăng bài',
                  textColor: textColor,
                  onTap: onCreatePost,
                ),
              ),
              Expanded(
                child: _QuickActionButton(
                  icon: Icons.image_outlined,
                  label: 'Thêm ảnh',
                  textColor: textColor,
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
  final Color textColor;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: kAmber, size: 20),
      label: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}