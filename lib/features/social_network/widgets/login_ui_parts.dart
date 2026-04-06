import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({
    super.key,
    required this.navy,
    required this.amber,
    required this.white,
  });

  final Color navy;
  final Color amber;
  final Color white;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
      child: Column(
        children: <Widget>[
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: amber,
              shape: BoxShape.circle,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: amber.withValues(alpha: 0.4),
                  blurRadius: 24,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Icon(Icons.directions_car_rounded, color: navy, size: 36),
          ),
          const SizedBox(height: 20),
          Text(
            'Lái Xe Thông Minh',
            style: TextStyle(
              color: white,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Ôn thi GPLX nhanh – đúng – chắc',
            style: TextStyle(
              color: white.withValues(alpha: 0.6),
              fontSize: 14,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 36),
        ],
      ),
    );
  }
}

class SectionLabel extends StatelessWidget {
  const SectionLabel({
    super.key,
    required this.text,
    required this.color,
  });

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
    );
  }
}

class OrDivider extends StatelessWidget {
  const OrDivider({
    super.key,
    required this.grey,
  });

  final Color grey;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: Divider(color: grey.withValues(alpha: 0.3))),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text('hoặc', style: TextStyle(fontSize: 12)),
        ),
        Expanded(child: Divider(color: grey.withValues(alpha: 0.3))),
      ],
    );
  }
}

class LoginErrorBox extends StatelessWidget {
  const LoginErrorBox({
    super.key,
    required this.message,
    required this.errorColor,
  });

  final String message;
  final Color errorColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: errorColor.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: errorColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: <Widget>[
          Icon(Icons.error_outline_rounded, color: errorColor, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: errorColor, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
