import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SocialAuthService {
  SocialAuthService._();

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  static Future<UserCredential> signInWithGoogle() async {
    try {
      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw FirebaseAuthException(
          code: 'sign-in-cancelled',
          message: 'Nguoi dung da huy dang nhap Google.',
        );
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      final User? user = userCredential.user;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'null-user',
          message: 'Khong lay duoc thong tin nguoi dung.',
        );
      }

      await _upsertUserProfile(user, provider: 'google');
      return userCredential;
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw FirebaseAuthException(
        code: 'google-sign-in-failed',
        message: 'Dang nhap Google that bai: $e',
      );
    }
  }

  static Future<UserCredential> signInWithFacebook() async {
    try {
      late final UserCredential userCredential;

      if (kIsWeb) {
        final FacebookAuthProvider provider = FacebookAuthProvider();
        provider.addScope('email');
        provider.setCustomParameters(<String, String>{'display': 'popup'});
        userCredential = await _auth.signInWithPopup(provider);
      } else {
        await FacebookAuth.instance.logOut();

        final LoginResult loginResult = await FacebookAuth.instance.login(
          permissions: const <String>['email', 'public_profile'],
          loginBehavior: defaultTargetPlatform == TargetPlatform.android
              ? LoginBehavior.webOnly
              : LoginBehavior.nativeWithFallback,
        );

        switch (loginResult.status) {
          case LoginStatus.success:
            final String? accessToken = loginResult.accessToken?.tokenString;
            if (accessToken == null || accessToken.isEmpty) {
              throw FirebaseAuthException(
                code: 'facebook-missing-token',
                message: 'Khong nhan duoc access token tu Facebook.',
              );
            }

            final OAuthCredential facebookAuthCredential =
                FacebookAuthProvider.credential(accessToken);
            userCredential = await _auth.signInWithCredential(
              facebookAuthCredential,
            );
            break;
          case LoginStatus.cancelled:
            throw FirebaseAuthException(
              code: 'sign-in-cancelled',
              message: 'Nguoi dung da huy dang nhap Facebook.',
            );
          case LoginStatus.failed:
            throw FirebaseAuthException(
              code: 'facebook-sign-in-failed',
              message: loginResult.message ?? 'Dang nhap Facebook that bai.',
            );
          case LoginStatus.operationInProgress:
            throw FirebaseAuthException(
              code: 'facebook-sign-in-in-progress',
              message: 'Dang nhap Facebook dang duoc xu ly.',
            );
        }
      }

      final User? user = userCredential.user;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'null-user',
          message: 'Khong lay duoc thong tin nguoi dung.',
        );
      }

      await _upsertUserProfile(user, provider: 'facebook');
      return userCredential;
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw FirebaseAuthException(
        code: 'facebook-sign-in-failed',
        message: 'Dang nhap Facebook that bai: $e',
      );
    }
  }

  static Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}

    if (!kIsWeb) {
      try {
        await FacebookAuth.instance.logOut();
      } catch (_) {}
    }

    await _auth.signOut();
  }

  static Future<void> _upsertUserProfile(
    User user, {
    required String provider,
  }) async {
    final DocumentReference<Map<String, dynamic>> userRef = _firestore
        .collection('users')
        .doc(user.uid);
    final DocumentSnapshot<Map<String, dynamic>> snap = await userRef.get();
    final Map<String, dynamic>? oldData = snap.data();

    final List<String> providerIds = user.providerData
        .map((UserInfo info) => info.providerId)
        .where((String id) => id.isNotEmpty)
        .toSet()
        .toList();

    final String resolvedDisplayName = _resolveDisplayName(user, oldData);
    final String resolvedPhotoUrl = _resolvePhotoUrl(user, oldData);

    final Map<String, dynamic> data = <String, dynamic>{
      'uid': user.uid,
      'email': user.email ?? (oldData?['email'] ?? ''),
      'displayName': resolvedDisplayName,
      'photoURL': resolvedPhotoUrl,
      'phoneNumber': user.phoneNumber ?? (oldData?['phoneNumber'] ?? ''),
      'provider': provider,
      'providers': providerIds,
      'role': oldData?['role'] ?? 'user',
      'status': oldData?['status'] ?? 'active',
      'reminder_wrong': oldData?['reminder_wrong'] ?? false,
      'wrong_reminder_enabled': oldData?['wrong_reminder_enabled'] ?? true,
      'fcm_tokens': oldData?['fcm_tokens'] ?? <String>[],
      'lastLoginAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (!snap.exists) {
      data['createdAt'] = FieldValue.serverTimestamp();
      await userRef.set(data);
      return;
    }

    await userRef.set(data, SetOptions(merge: true));
  }

  static String _resolveDisplayName(User user, Map<String, dynamic>? oldData) {
    final String? oldDisplayName = oldData?['displayName'] as String?;
    if (oldDisplayName != null && oldDisplayName.trim().isNotEmpty) {
      return oldDisplayName.trim();
    }

    final String? currentDisplayName = user.displayName;
    if (currentDisplayName != null && currentDisplayName.trim().isNotEmpty) {
      return currentDisplayName.trim();
    }

    final String? email = user.email;
    if (email != null && email.trim().isNotEmpty) {
      return email.trim().split('@').first;
    }

    return 'Nguoi dung';
  }

  static String _resolvePhotoUrl(User user, Map<String, dynamic>? oldData) {
    final String? currentPhotoUrl = user.photoURL;
    if (currentPhotoUrl != null && currentPhotoUrl.trim().isNotEmpty) {
      return currentPhotoUrl.trim();
    }

    final String? oldPhotoUrl = oldData?['photoURL'] as String?;
    if (oldPhotoUrl != null && oldPhotoUrl.trim().isNotEmpty) {
      return oldPhotoUrl.trim();
    }

    return '';
  }
}
