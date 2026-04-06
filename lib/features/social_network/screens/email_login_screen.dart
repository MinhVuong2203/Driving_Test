import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driving_test_prep/features/social_network/screens/register_with_otp_screen.dart';
import 'package:driving_test_prep/features/social_network/widgets/authenticated_user.dart';
import 'package:driving_test_prep/features/social_network/widgets/login_action_buttons.dart';
import 'package:driving_test_prep/features/social_network/widgets/login_text_field.dart';
import 'package:driving_test_prep/features/social_network/widgets/login_ui_parts.dart';
import 'package:driving_test_prep/features/social_network/utils/auth_validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

const Color _kNavy = Color(0xFF0D1B3E);
const Color _kAmber = Color(0xFFF5A623);
const Color _kWhite = Color(0xFFFFFFFF);
const Color _kGrey = Color(0xFF8A9BB0);
const Color _kInputBg = Color(0xFFF0F3F8);
const Color _kError = Color(0xFFD93025);

class EmailLoginScreen extends StatefulWidget {
  const EmailLoginScreen({super.key});

  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();

  bool _isLoading = false;
  bool _isSigningOut = false;
  bool _obscurePassword = true;
  String? _error;

  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();
    _linkSubscription = _appLinks.uriLinkStream.listen((_) {});
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final String email = _emailCtrl.text.trim();

    try {
      final UserCredential credential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: _passwordCtrl.text,
      );

      final User? user = credential.user;
      if (user != null) {
        await _upsertUserProfile(user: user, email: email);
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _error = switch (e.code) {
          'user-not-found' => 'Không tìm thấy tài khoản.',
          'wrong-password' => 'Sai mật khẩu.',
          'invalid-email' => 'Email không hợp lệ.',
          'invalid-credential' => 'Thông tin đăng nhập không đúng.',
          _ => 'Đăng nhập thất bại: ${e.message ?? e.code}',
        };
      });
    } on FirebaseException catch (e) {
      setState(() => _error = 'Cập nhật hồ sơ thất bại: ${e.message ?? e.code}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _register() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const RegisterWithOtpScreen()),
    );
  }

  Future<void> _signOut() async {
    setState(() => _isSigningOut = true);
    try {
      await FirebaseAuth.instance.signOut();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đăng xuất thất bại, thử lại nhé.')),
      );
    } finally {
      if (mounted) setState(() => _isSigningOut = false);
    }
  }

  Future<void> _upsertUserProfile({
    required User user,
    required String email,
  }) async {
    final String displayName =
    user.displayName?.isNotEmpty == true ? user.displayName! : email.split('@').first;

    final DocumentReference<Map<String, dynamic>> docRef =
    FirebaseFirestore.instance.collection('users').doc(user.uid);

    await docRef.set({
      'uid': user.uid,
      'email': email,
      'displayName': displayName,
      'role': 'user',
      'status': 'active',
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: _kNavy,
            body: Center(child: CircularProgressIndicator(color: _kAmber)),
          );
        }

        final User? user = snapshot.data;
        if (user != null) {
          return AuthenticatedUserWidget(
            user: user,
            isSigningOut: _isSigningOut,
            onSignOut: _signOut,
          );
        }

        return Scaffold(
          backgroundColor: _kNavy,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const LoginHeader(
                    navy: _kNavy,
                    amber: _kAmber,
                    white: _kWhite,
                  ),
                  _buildCard(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCard() {
    return Container(
      decoration: const BoxDecoration(
        color: _kWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.fromLTRB(28, 36, 28, 40),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Đăng nhập',
              style: TextStyle(
                color: _kNavy,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Chào mừng bạn quay trở lại 👋',
              style: TextStyle(color: _kGrey, fontSize: 13),
            ),
            const SizedBox(height: 28),
            const SectionLabel(text: 'Email', color: _kNavy),
            const SizedBox(height: 6),
            LoginTextField(
              controller: _emailCtrl,
              hint: 'example@gmail.com',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: AuthValidators.email,
              navy: _kNavy,
              grey: _kGrey,
              inputBg: _kInputBg,
              amber: _kAmber,
              error: _kError,
            ),
            const SizedBox(height: 20),
            const SectionLabel(text: 'Mật khẩu', color: _kNavy),
            const SizedBox(height: 6),
            LoginTextField(
              controller: _passwordCtrl,
              hint: '••••••••',
              icon: Icons.lock_outline_rounded,
              obscureText: _obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: _kGrey,
                  size: 20,
                ),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
              validator: AuthValidators.password,
              navy: _kNavy,
              grey: _kGrey,
              inputBg: _kInputBg,
              amber: _kAmber,
              error: _kError,
            ),
            const SizedBox(height: 12),
            if (_error != null) ...<Widget>[
              LoginErrorBox(message: _error!, errorColor: _kError),
              const SizedBox(height: 12),
            ],
            PrimaryActionButton(
              label: 'Đăng nhập',
              isLoading: _isLoading,
              onPressed: _signIn,
              amber: _kAmber,
              navy: _kNavy,
            ),
            const SizedBox(height: 16),
            const OrDivider(grey: _kGrey),
            const SizedBox(height: 16),
            SecondaryActionButton(
              label: 'Tạo tài khoản mới',
              onPressed: _register,
              navy: _kNavy,
            ),
            const SizedBox(height: 28),
            Center(
              child: Text(
                'Bằng cách đăng nhập, bạn đồng ý với\nChính sách & Điều khoản sử dụng.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _kGrey.withValues(alpha: 0.7),
                  fontSize: 11,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
