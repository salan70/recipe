import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe/repository/firebase/user_repository.dart';

class UserStateNotifier extends StateNotifier<User?> {
  UserStateNotifier() : super(null);

  // アプリ開始
  Future appStarted() async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    User? user = _firebaseAuth.currentUser;
    print(user);
    if (user == null) {
      print('create');
      await _firebaseAuth.signInAnonymously();
      state = user;
    } else {
      state = user;
    }
  }

  Future signUp(String email, String password) async {
    UserRepository authRepository = UserRepository();
    final user = await authRepository.signUp(email, password);
    final AuthCredential credential =
        EmailAuthProvider.credential(email: email, password: password);
    if (user.isAnonymous) {
      await user.linkWithCredential(credential);
    } else {
      await FirebaseAuth.instance.signInWithCredential(credential);
    }
    authRepository.addUser(user);
    print('登録完了');
  }

  Future signOut() async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    await _firebaseAuth.signOut();
  }
}
