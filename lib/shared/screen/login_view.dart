import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:driving_test_prep/features/social_network/screens/home_feed_screen.dart';
import 'package:driving_test_prep/features/social_network/screens/register_with_otp_screen.dart';
import 'package:driving_test_prep/features/social_network/widgets/login_action_buttons.dart';
import 'package:driving_test_prep/features/social_network/widgets/login_text_field.dart';
import 'package:driving_test_prep/features/social_network/widgets/login_ui_parts.dart';
import 'package:driving_test_prep/features/social_network/utils/auth_validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../data/repository/social_auth_repository.dart';
import '../../features/social_network/widgets/other_login_method.dart';

const Color _kNavy = Color(0xFF0D1B3E);
const Color _kAmber = Color(0xFFF5A623);
const Color _kWhite = Color(0xFFFFFFFF);
const Color _kGrey = Color(0xFF8A9BB0);
const Color _kInputBg = Color(0xFFF0F3F8);
const Color _kError = Color(0xFFD93025);
const Color _kDarkBackground = Color(0xFF0F172A);
const Color _kDarkCard = Color(0xFF111827);
const Color _kDarkInputBg = Color(0xFF1F2937);
const Color _kDarkText = Color(0xFFF8FAFC);
const Color _kDarkMuted = Color(0xFFCBD5E1);

typedef LoginSuccessCallback = Future<void> Function(User user);

class LoginScreen extends StatefulWidget {
  final LoginSuccessCallback? onLoginSuccess;
  final Widget fallbackSuccessScreen;

  const LoginScreen({
    super.key,
    this.onLoginSuccess,
    this.fallbackSuccessScreen = const HomeFeedScreen(),
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final SocialAuthRepository _socialAuthRepo = SocialAuthRepository.instance;
  late final Stream<User?> _authStateStream;

  bool _isLoading = false;
  // bool _isSigningOut = false;
  final ValueNotifier<bool> _obscurePassword = ValueNotifier<bool>(true);
  String? _error;

  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _authStateStream = FirebaseAuth.instance.authStateChanges();
    _appLinks = AppLinks();
    _linkSubscription = _appLinks.uriLinkStream.listen((_) {});
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _obscurePassword.dispose();
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<void> _handleLoginSuccess(User user) async {
    if (widget.onLoginSuccess != null) {
      await widget.onLoginSuccess!(user); // caller tự điều hướng
    }
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final String email = _emailCtrl.text.trim();

    try {
      final UserCredential credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: email,
            password: _passwordCtrl.text,
          );

      final User? user = credential.user;
      if (user != null) {
        await _handleLoginSuccess(user);
        return;
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
      setState(
        () => _error = 'Cập nhật hồ sơ thất bại: ${e.message ?? e.code}',
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _register() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const RegisterWithOtpScreen()));
  }

  // Future<void> _signOut() async {
  //   setState(() => _isSigningOut = true);
  //   try {
  //     await GoogleAuthService.signOut();
  //   } catch (_) {
  //     if (!mounted) return;
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Đăng xuất thất bại, thử lại nhé.')),
  //     );
  //   } finally {
  //     if (mounted) setState(() => _isSigningOut = false);
  //   }
  // }

  // Future<void> _upsertUserProfile({
  //   required User user,
  //   required String email,
  // }) async {
  //   final String displayName =
  //   user.displayName?.isNotEmpty == true ? user.displayName! : email.split('@').first;
  //
  //   final DocumentReference<Map<String, dynamic>> docRef =
  //   FirebaseFirestore.instance.collection('users').doc(user.uid);
  //
  //   await docRef.set({
  //     'uid': user.uid,
  //     'email': email,
  //     'displayName': displayName,
  //     'role': 'user',
  //     'status': 'active',
  //     'updatedAt': FieldValue.serverTimestamp(),
  //   }, SetOptions(merge: true));
  // }

  void googleSignIn() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final credential = await _socialAuthRepo.signInWithGoogle();
      if (!mounted) return;

      final user = credential.user;
      if (user != null) {
        await _handleLoginSuccess(user);
        return;
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message ?? 'Đăng nhập Google thất bại.';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark ? _kDarkBackground : _kNavy;

    return StreamBuilder<User?>(
      stream: _authStateStream,
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: background,
            body: const Center(
              child: CircularProgressIndicator(color: _kAmber),
            ),
          );
        }

        final User? user = snapshot.data;
        if (user != null) {
          return widget.fallbackSuccessScreen;
        }

        return Scaffold(
          appBar: AppBar(backgroundColor: background, elevation: 0),
          backgroundColor: background,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  LoginHeader(navy: background, amber: _kAmber, white: _kWhite),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? _kDarkCard : _kWhite;
    final textColor = isDark ? _kDarkText : _kNavy;
    final subTextColor = isDark ? _kDarkMuted : _kGrey;
    final inputBg = isDark ? _kDarkInputBg : _kInputBg;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.fromLTRB(28, 36, 28, 40),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Đăng nhập',
              style: TextStyle(
                color: textColor,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Chào mừng bạn quay trở lại 👋',
              style: TextStyle(color: subTextColor, fontSize: 13),
            ),
            const SizedBox(height: 28),
            SectionLabel(text: 'Email', color: textColor),
            const SizedBox(height: 6),
            LoginTextField(
              controller: _emailCtrl,
              hint: 'example@gmail.com',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: AuthValidators.email,
              navy: textColor,
              grey: subTextColor,
              inputBg: inputBg,
              amber: _kAmber,
              error: _kError,
            ),
            const SizedBox(height: 20),
            SectionLabel(text: 'Mật khẩu', color: textColor),
            const SizedBox(height: 6),
            ValueListenableBuilder<bool>(
              valueListenable: _obscurePassword,
              builder: (_, bool isObscured, child) {
                return LoginTextField(
                  controller: _passwordCtrl,
                  hint: '••••••••',
                  icon: Icons.lock_outline_rounded,
                  obscureText: isObscured,
                  suffixIcon: IconButton(
                    icon: Icon(
                      isObscured
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: subTextColor,
                      size: 20,
                    ),
                    onPressed: () => _obscurePassword.value = !isObscured,
                  ),
                  validator: AuthValidators.password,
                  navy: textColor,
                  grey: subTextColor,
                  inputBg: inputBg,
                  amber: _kAmber,
                  error: _kError,
                );
              },
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
            OtherLoginMethod(onGoogleTap: googleSignIn),
            OrDivider(grey: subTextColor, textColor: subTextColor),
            const SizedBox(height: 16),
            SecondaryActionButton(
              label: 'Tạo tài khoản mới',
              onPressed: _register,
              navy: textColor,
            ),
            const SizedBox(height: 28),
            Center(
              child: Text(
                'Bằng cách đăng nhập, bạn đồng ý với\nChính sách & Điều khoản sử dụng.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: subTextColor.withValues(alpha: 0.75),
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
