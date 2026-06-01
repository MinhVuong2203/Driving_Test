import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driving_test_prep/data/repository/google_auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountStatusGate extends StatelessWidget {
  final Widget child;
  final Widget? unauthenticatedChild;
  final String featureName;

  const AccountStatusGate({
    super.key,
    required this.child,
    required this.featureName,
    this.unauthenticatedChild,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const _AccountStatusLoading();
        }

        final user = authSnapshot.data;
        if (user == null) {
          return unauthenticatedChild ?? const _SignInRequiredScreen();
        }

        return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .snapshots(),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting &&
                !userSnapshot.hasData) {
              return const _AccountStatusLoading();
            }

            final data = userSnapshot.data?.data();
            final status = data?['status']?.toString().trim().toLowerCase();
            final unlockAt = _parseUnlockAt(data?['unlockAt']);

            if (status == 'active') {
              return child;
            }

            if (status == 'locked' &&
                unlockAt != null &&
                unlockAt.isBefore(DateTime.now()) &&
                userSnapshot.data != null) {
              return _AccountAutoUnlock(
                userRef: userSnapshot.data!.reference,
                featureName: featureName,
                child: child,
              );
            }

            return AccountLockedScreen(
              featureName: featureName,
              status: status,
              unlockAt: unlockAt,
            );
          },
        );
      },
    );
  }

  static DateTime? _parseUnlockAt(Object? value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);

    return null;
  }
}

class _AccountAutoUnlock extends StatefulWidget {
  final DocumentReference<Map<String, dynamic>> userRef;
  final String featureName;
  final Widget child;

  const _AccountAutoUnlock({
    required this.userRef,
    required this.featureName,
    required this.child,
  });

  @override
  State<_AccountAutoUnlock> createState() => _AccountAutoUnlockState();
}

class _AccountAutoUnlockState extends State<_AccountAutoUnlock> {
  late final Future<void> _unlockFuture;

  @override
  void initState() {
    super.initState();
    _unlockFuture = widget.userRef.update({
      'status': 'active',
      'unlockAt': FieldValue.delete(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _unlockFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            !snapshot.hasError) {
          return widget.child;
        }

        if (snapshot.hasError) {
          return AccountLockedScreen(
            featureName: widget.featureName,
            status: 'locked',
          );
        }

        return const _AccountStatusLoading();
      },
    );
  }
}

class AccountLockedScreen extends StatefulWidget {
  final String featureName;
  final String? status;
  final DateTime? unlockAt;

  const AccountLockedScreen({
    super.key,
    required this.featureName,
    this.status,
    this.unlockAt,
  });

  @override
  State<AccountLockedScreen> createState() => _AccountLockedScreenState();
}

class _AccountLockedScreenState extends State<AccountLockedScreen> {
  bool _isSigningOut = false;

  String _formatUnlockAt(DateTime value) {
    final local = value.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final year = local.year.toString();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');

    return '$day/$month/$year $hour:$minute';
  }

  Future<void> _signOut() async {
    setState(() => _isSigningOut = true);

    try {
      await GoogleAuthRepository.instance.signOut();
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đăng xuất thất bại, vui lòng thử lại.')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSigningOut = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark ? const Color(0xFF111827) : const Color(0xFFF6F8FB);
    final surface = isDark ? const Color(0xFF1F2937) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF0D1B3E);
    final mutedColor = isDark ? const Color(0xFFD1D5DB) : const Color(0xFF6B7280);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: Text(widget.featureName),
        backgroundColor: surface,
        foregroundColor: textColor,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 420),
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.lock_outline_rounded,
                  color: Color(0xFFD93025),
                  size: 46,
                ),
                const SizedBox(height: 14),
                Text(
                  'Tài khoản đã bị khóa',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${widget.featureName} không khả dụng do tài khoản của bạn đang bị khóa. Vui lòng liên hệ bộ phận hỗ trợ để biết thêm chi tiết.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: mutedColor,
                    fontSize: 14,
                    height: 1.45,
                  ),
                ),
                if ((widget.status ?? '').isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Trạng thái hiện tại: ${widget.status}',
                    style: TextStyle(
                      color: mutedColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                if (widget.unlockAt != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Ngày mở khóa ${_formatUnlockAt(widget.unlockAt!)}',
                    style: TextStyle(
                      color: mutedColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _isSigningOut ? null : _signOut,
                    icon: _isSigningOut
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.logout_rounded),
                    label: Text(_isSigningOut ? 'Đang xuất...' : 'Đăng xuất'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AccountStatusLoading extends StatelessWidget {
  const _AccountStatusLoading();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

class _SignInRequiredScreen extends StatelessWidget {
  const _SignInRequiredScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Vui lòng đăng nhập để tiếp tục.')),
    );
  }
}
