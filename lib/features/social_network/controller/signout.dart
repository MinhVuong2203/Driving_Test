import 'package:flutter/material.dart';

import '../../../data/repository/google_auth_repository.dart';

class SignOutController {
  static Future<void> signOut({
    required BuildContext context,
    required void Function(bool) setSigningOut,
    required bool Function() isMounted,
  }) async {
    setSigningOut(true);
    try {
      await GoogleAuthRepository.instance.signOut();
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
