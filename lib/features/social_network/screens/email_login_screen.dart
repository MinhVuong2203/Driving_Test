import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:driving_test_prep/features/social_network/widgets/auth_form.dart';
import 'package:driving_test_prep/features/social_network/widgets/authenticated_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmailLoginScreen extends StatefulWidget {
  const EmailLoginScreen({super.key});

  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  static const String _pendingEmailKey = 'pending_email_link_sign_in';

  bool _isLoading = false;
  bool _isSigningOut = false;
  String? _error;

  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _initEmailLinkListener();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initEmailLinkListener() async {
    _appLinks = AppLinks();

    final Uri? initialLink = await _appLinks.getInitialLink();
    if (initialLink != null) {
      await _consumeEmailLink(initialLink.toString());
    }

    _linkSubscription = _appLinks.uriLinkStream.listen((Uri uri) async {
      await _consumeEmailLink(uri.toString());
    });
  }

  Future<void> _signIn(String email, String password) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _error = switch (e.code) {
          'user-not-found' => 'Khong tim thay tai khoan.',
          'wrong-password' => 'Sai mat khau.',
          'invalid-email' => 'Email khong hop le.',
          'invalid-credential' => 'Thong tin dang nhap khong dung.',
          _ => 'Dang nhap that bai: ${e.message ?? e.code}',
        };
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _register(String email, String password) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _error = switch (e.code) {
          'email-already-in-use' => 'Email da duoc su dung.',
          'weak-password' => 'Mat khau qua yeu.',
          'invalid-email' => 'Email khong hop le.',
          _ => 'Dang ky that bai: ${e.message ?? e.code}',
        };
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _sendEmailLink(String email) async {
    final String cleanedEmail = email.trim();
    if (cleanedEmail.isEmpty) {
      setState(() => _error = 'Vui long nhap email de gui link.');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final ActionCodeSettings settings = ActionCodeSettings(
        // url: 'https://myapp-8fb3f.firebaseapp.com/__/auth/action?mode=action&oobCode=code',
        url: 'https://myapp-8fb3f.firebaseapp.com/emailSignIn',
        handleCodeInApp: true,
        androidPackageName: 'com.example.driving_test_prep',
        androidInstallApp: true,
        androidMinimumVersion: '1',
        iOSBundleId: 'com.example.drivingTestPrep',
      );

      await FirebaseAuth.instance.sendSignInLinkToEmail(
        email: cleanedEmail,
        actionCodeSettings: settings,
      );

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(_pendingEmailKey, cleanedEmail);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Da gui link dang nhap den email cua ban.')),
      );
    } on FirebaseAuthException catch (e) {
      setState(() => _error = 'Gui link that bai: ${e.message ?? e.code}');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _consumeEmailLink(String link) async {
    if (!FirebaseAuth.instance.isSignInWithEmailLink(link)) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? savedEmail = prefs.getString(_pendingEmailKey);

      if (savedEmail == null || savedEmail.isEmpty) {
        setState(() {
          _error = 'Khong tim thay email da luu. Vui long gui lai email link.';
        });
        return;
      }

      await FirebaseAuth.instance.signInWithEmailLink(
        email: savedEmail,
        emailLink: link,
      );

      await prefs.remove(_pendingEmailKey);
    } on FirebaseAuthException catch (e) {
      setState(() => _error = 'Dang nhap Email Link that bai: ${e.message ?? e.code}');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _signOut() async {
    setState(() => _isSigningOut = true);
    try {
      await FirebaseAuth.instance.signOut();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dang xuat that bai, thu lai nhe.')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSigningOut = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
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
          appBar: AppBar(title: const Text('Dang nhap')),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: AuthFormWidget(
              isLoading: _isLoading,
              errorText: _error,
              onSignIn: _signIn,
              onRegister: _register,
              onSendEmailLink: _sendEmailLink,
            ),
          ),
        );
      },
    );
  }
}
