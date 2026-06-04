import 'package:flutter/material.dart';

import '../../../data/repository/google_auth_repository.dart';
import '../../../data/services/sqlite/wrong_question_notification_service.dart';

class SignOutController {
  static Future<void> signOut({
    required BuildContext context,
    required void Function(bool) setSigningOut,
    required bool Function() isMounted,
  }) async {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    setSigningOut(true);
    try {
      await WrongQuestionNotificationService.instance.removeCurrentUserToken();
      await GoogleAuthRepository.instance.signOut();
    } catch (_) {
      if (!context.mounted || !isMounted()) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đăng xuất thất bại, thử lại nhé.')),
      );
    } finally {
      if (isMounted()) setSigningOut(false);
    }
  }
}
