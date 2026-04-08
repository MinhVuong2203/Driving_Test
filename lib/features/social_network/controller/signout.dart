import 'package:flutter/material.dart';
import '../services/google_auth_service.dart';

class SignOutController {
  static Future<void> signOut({
    required BuildContext context,
    required void Function(bool) setSigningOut,
    required bool Function() isMounted,
  }) async {
    setSigningOut(true);
    try {
      await GoogleAuthService.signOut();
    } catch (_) {
      if (!isMounted()) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đăng xuất thất bại, thử lại nhé.')),
      );
    } finally {
      if (isMounted()) setSigningOut(false);
    }
  }
}
