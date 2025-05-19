import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController(FirebaseAuth.instance);
});

class AuthController {
  final FirebaseAuth _auth;

  AuthController(this._auth);

  // Sign up
  Future<User?> signUp(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {

      return null;
    }
  }

  // Login
  Future<User?> login(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      return null;
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Auth State
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
