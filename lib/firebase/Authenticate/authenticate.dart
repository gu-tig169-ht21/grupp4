// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _authenticator;

  AuthenticationService(this._authenticator);

  Stream<User?> get authstatechanges => _authenticator.authStateChanges();

  // ignore: non_constant_identifier_names
  Future SignIn({required String email, required String password}) async {
    try {
      await _authenticator.signInWithEmailAndPassword(
          email: email, password: password);
      return "Signed in";
    } on FirebaseAuthException catch (error) {
      return error.message.toString();
    }
  }

  // ignore: non_constant_identifier_names
  Future<String?> SignUp(
      {required String email, required String password}) async {
    try {
      await _authenticator.createUserWithEmailAndPassword(
          email: email, password: password);
      return "Signed Up!";
    } on FirebaseAuthException catch (error) {
      return error.message.toString();
    }
  }

  Future<void> signOut() async {
    await _authenticator.signOut();
  }
}
