import 'package:flutter/material.dart';

class OtherLoginMethod extends StatelessWidget {
  const OtherLoginMethod({super.key, this.onGoogleTap, this.onFacebookTap});

  final VoidCallback? onGoogleTap;
  final VoidCallback? onFacebookTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final textColor = isDark
        ? const Color(0xFFE5E7EB)
        : const Color(0xFF374151);
    final subTextColor = isDark
        ? const Color(0xFFCBD5E1)
        : const Color(0xFF6B7280);
    final borderColor = isDark
        ? const Color(0xFF334155)
        : const Color(0xFFE5E7EB);
    final buttonBg = isDark ? const Color(0xFF1F2937) : Colors.white;

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(child: Divider(color: borderColor)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Hoặc tiếp tục bằng',
                style: TextStyle(
                  color: subTextColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(child: Divider(color: borderColor)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: <Widget>[
            Expanded(
              child: _LoginMethodButton(
                icon: Icons.g_mobiledata_rounded,
                label: 'Google',
                onTap: onGoogleTap,
                backgroundColor: buttonBg,
                textColor: textColor,
                borderColor: borderColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _LoginMethodButton(
                icon: Icons.facebook_rounded,
                label: 'Facebook',
                onTap: onFacebookTap,
                backgroundColor: buttonBg,
                textColor: textColor,
                borderColor: borderColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _LoginMethodButton extends StatelessWidget {
  const _LoginMethodButton({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          children: <Widget>[
            Icon(icon, size: 30, color: textColor),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
