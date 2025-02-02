import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Sign in with email and password
  Future<bool> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  // Sign up with email and password
  Future<UserCredential?> signUp(String email, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential;
    } catch (e) {
      print(e);
    }
    return null;
  }

  // Sign out
  Future signOut() async {
    await _firebaseAuth.signOut();
  }
}
