import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:recipe/repository/firebase/user_repository.dart';

class AuthStateNotifier extends StateNotifier<User?> {
  AuthStateNotifier() : super(null);

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // アプリ開始
  Future appStarted() async {
    if (_firebaseAuth.currentUser == null) {
      print('create');
      await _firebaseAuth.signInAnonymously();
    }
    state = _firebaseAuth.currentUser;
  }

  void authStateUpdate() {
    state = _firebaseAuth.currentUser;
  }

  Future signOut() async {
    await _firebaseAuth.signOut();
    await _firebaseAuth.signInAnonymously();
    state = _firebaseAuth.currentUser;
    print('signOut');
  }

  /// Email
  // Future signUpWithEmail(String email, String password) async {
  //   final currentUser = _firebaseAuth.currentUser;
  //   final AuthCredential credential =
  //       EmailAuthProvider.credential(email: email, password: password);
  //   if (currentUser!.isAnonymous) {
  //     await currentUser.linkWithCredential(credential);
  //     print('a');
  //   } else {
  //     await FirebaseAuth.instance.signInWithCredential(credential);
  //     print('b');
  //   }
  //   state = _firebaseAuth.currentUser;
  //   print('登録完了');
  // }

  Future<String?> loginWithEmail(String email, String password) async {
    try {
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

  /// Google Account
  // Future signUpWithGoogle() async {
  //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //   final GoogleSignInAuthentication googleAuth =
  //       await googleUser!.authentication;
  //
  //   final currentUser = _firebaseAuth.currentUser;
  //   final AuthCredential credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth.accessToken,
  //     idToken: googleAuth.idToken,
  //   );
  //   if (currentUser!.isAnonymous) {
  //     await currentUser.linkWithCredential(credential);
  //     print('a');
  //   } else {
  //     await FirebaseAuth.instance.signInWithCredential(credential);
  //     print('b');
  //   }
  //   state = _firebaseAuth.currentUser;
  //   print('登録完了');
  // }
}
