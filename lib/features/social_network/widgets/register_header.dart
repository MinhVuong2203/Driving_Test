import 'package:flutter/material.dart';

// ─── Color tokens (dùng chung toàn bộ register flow) ─────────────────────────
const Color kNavy   = Color(0xFF0D1B3E);
const Color kAmber  = Color(0xFFF5A623);
const Color kWhite  = Color(0xFFFFFFFF);
const Color kGrey   = Color(0xFF8A9BB0);
const Color kInputBg = Color(0xFFF0F3F8);
const Color kError  = Color(0xFFD93025);
const Color kGreen  = Color(0xFF1DB954);

/// Header phần trên màn hình đăng ký (nền navy, logo, tagline).
class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 32),
      child: Column(
        children: <Widget>[
          // Icon logo
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: kAmber,
              shape: BoxShape.circle,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: kAmber.withOpacity(0.45),
                  blurRadius: 24,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: const Icon(Icons.app_registration_rounded, color: kNavy, size: 32),
          ),
          const SizedBox(height: 18),
          const Text(
            'Tạo tài khoản',
            style: TextStyle(
              color: kWhite,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Đăng ký để bắt đầu luyện thi GPLX',
            style: TextStyle(
              color: kWhite.withOpacity(0.6),
              fontSize: 13,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}