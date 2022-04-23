import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe/repository/firebase/user_repository.dart';

class AuthStateNotifier extends StateNotifier<User?> {
  AuthStateNotifier() : super(null);

  // アプリ開始
  Future appStarted() async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    if (_firebaseAuth.currentUser == null) {
      print('create');
      await _firebaseAuth.signInAnonymously();
    }
    state = _firebaseAuth.currentUser;
  }

  Future signUp(String email, String password) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final currentUser = _firebaseAuth.currentUser;
    final AuthCredential credential =
        EmailAuthProvider.credential(email: email, password: password);
    if (currentUser!.isAnonymous) {
      await currentUser.linkWithCredential(credential);
      print('a');
    } else {
      await FirebaseAuth.instance.signInWithCredential(credential);
      print('b');
    }
    state = _firebaseAuth.currentUser;
    print('登録完了');
  }

  Future<String?> login(String email, String password) async {
    try {
      final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      state = _firebaseAuth.currentUser;
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future signOut() async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    await _firebaseAuth.signOut();
    await _firebaseAuth.signInAnonymously();
    state = _firebaseAuth.currentUser;
    print('signOut');
  }
}
