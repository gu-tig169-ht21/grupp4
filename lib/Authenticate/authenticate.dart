// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_first_app/Authenticate/active_user.dart';
import 'package:provider/provider.dart';

class AuthenticationService {
  final FirebaseAuth _authenticator;

  AuthenticationService(this._authenticator);

  ActiveUser? fromFirebaseUser(User user) {
    return user != null ? ActiveUser(uid: user.uid) : null;
  }

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
      UserCredential result = await _authenticator
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return "Signed Up!";
    } on FirebaseAuthException catch (error) {
      return error.message.toString();
    }
  }

  Future<void> signOut() async {
    await _authenticator.signOut();
  }
}
