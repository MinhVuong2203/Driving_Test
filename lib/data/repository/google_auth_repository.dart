import 'package:driving_test_prep/data/services/firebase/google_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';


class GoogleAuthRepository {
  GoogleAuthRepository._();

  static final GoogleAuthRepository instance = GoogleAuthRepository._();

  Future<UserCredential> signInWithGoogle() {
    return GoogleAuthService.signInWithGoogle();
  }

  Future<void> signOut() {
    return GoogleAuthService.signOut();
  }
}
