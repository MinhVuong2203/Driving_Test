import 'package:flutter/material.dart';

import '../../../data/repository/social_auth_repository.dart';

class SignOutController {
  static Future<void> signOut({
    required BuildContext context,
    required void Function(bool) setSigningOut,
    required bool Function() isMounted,
  }) async {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    setSigningOut(true);
    try {
      await SocialAuthRepository.instance.signOut();
    } catch (_) {
      if (!isMounted()) return;
      messenger.showSnackBar(
        const SnackBar(content: Text('Dang xuat that bai, thu lai nhe.')),
      );
    } finally {
      if (isMounted()) setSigningOut(false);
    }
  }
}
