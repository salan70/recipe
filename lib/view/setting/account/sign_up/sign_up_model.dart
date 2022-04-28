import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:recipe/domain/recipe.dart';
import 'package:recipe/repository/firebase/user_repository.dart';

class SignUpModel extends ChangeNotifier {
  final UserRepository _userRepository = UserRepository();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String?> signUpWithEmail(String email, String password) async {
    //TODO repositoryと分ける
    final currentUser = _firebaseAuth.currentUser;

    try {
      final AuthCredential credential =
          EmailAuthProvider.credential(email: email, password: password);
      // 匿名アカウントとのリンク
      _linkWithAnonymousAccount(currentUser!, credential);
      return null;
    } catch (e) {
      //TODO errorTextを日本語にする
      return e.toString();
    }
  }

  Future<String?> signUpWithGoogle() async {
    //TODO repositoryと分ける
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final currentUser = _firebaseAuth.currentUser;

    try {
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // 匿名アカウントとのリンク
      _linkWithAnonymousAccount(currentUser!, credential);
      return null;
    } catch (e) {
      //TODO errorTextを日本語にする
      return e.toString();
    }
  }

  Future _linkWithAnonymousAccount(
      User currentUser, AuthCredential credential) async {
    if (currentUser.isAnonymous) {
      await currentUser.linkWithCredential(credential);
    } else {
      await FirebaseAuth.instance.signInWithCredential(credential);
    }
  }
}
