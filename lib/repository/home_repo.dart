import 'package:firebase_auth/firebase_auth.dart';

class HomeRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> loginSplashUser({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
