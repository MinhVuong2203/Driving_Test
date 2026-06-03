import 'package:driving_test_prep/data/services/firebase/social_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SocialAuthRepository {
  SocialAuthRepository._();

  static final SocialAuthRepository instance = SocialAuthRepository._();

  Future<UserCredential> signInWithGoogle() {
    return SocialAuthService.signInWithGoogle();
  }

  Future<UserCredential> signInWithFacebook() {
    return SocialAuthService.signInWithFacebook();
  }

  Future<void> signOut() {
    return SocialAuthService.signOut();
  }
}
