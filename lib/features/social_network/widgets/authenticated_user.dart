import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthenticatedUserWidget extends StatelessWidget {
  final User user;
  final bool isSigningOut;
  final Future<void> Function() onSignOut;

  const AuthenticatedUserWidget({
    super.key,
    required this.user,
    required this.isSigningOut,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Xin chào: ${user.email ?? 'User'}'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: isSigningOut ? null : onSignOut,
              child: isSigningOut
                  ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : const Text('Đăng xuất'),
            ),
          ],
        ),
      ),
    );
  }
}
