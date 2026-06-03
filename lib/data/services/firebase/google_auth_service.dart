import 'package:driving_test_prep/data/services/firebase/social_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GoogleAuthService {
  GoogleAuthService._();

  static Future<UserCredential> signInWithGoogle() {
    return SocialAuthService.signInWithGoogle();
  }

  static Future<void> signOut() {
    return SocialAuthService.signOut();
  }
}
