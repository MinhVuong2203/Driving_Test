import 'package:firebase_auth/firebase_auth.dart';

import '../datasource/firebase/service/google_auth_service.dart';

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
