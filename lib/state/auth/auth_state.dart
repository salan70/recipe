import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:recipe/repository/firebase/user_repository.dart';
import 'package:recipe/view/setting/account/sign_up/sign_up_model.dart';

class AuthStateNotifier extends StateNotifier<User?> {
  AuthStateNotifier() : super(null);

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  SignUpModel _signUpModel = SignUpModel();

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
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.signOut();
    await firebaseAuth.signInAnonymously();
    state = firebaseAuth.currentUser;
  }

  /// Email
  Future<String?> signUpWithEmail(String email, String password) async {
    final currentUser = _firebaseAuth.currentUser;
    try {
      final AuthCredential credential =
          EmailAuthProvider.credential(email: email, password: password);
      // 匿名アカウントとのリンク
      if (currentUser!.isAnonymous) {
        await currentUser.linkWithCredential(credential);
        state = _firebaseAuth.currentUser;
        print(state!.email.toString());
      } else {
        await FirebaseAuth.instance.signInWithCredential(credential);
      }
      return null;
    } catch (e) {
      //TODO errorTextを日本語にする
      return e.toString();
    }
  }

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
  Future<String?> signUpWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    final currentUser = _firebaseAuth.currentUser;

    try {
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      if (currentUser!.isAnonymous) {
        await currentUser.linkWithCredential(credential);
        print('a');
      } else {
        await FirebaseAuth.instance.signInWithCredential(credential);
        print('b');
      }
      state = _firebaseAuth.currentUser;
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> loginWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    try {
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      state = _firebaseAuth.currentUser;
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  /// Apple Account
  Future<String?> signUpWithApple() async {
    final currentUser = _firebaseAuth.currentUser;
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      OAuthProvider oauthProvider = OAuthProvider('apple.com');
      final credential = oauthProvider.credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      if (currentUser!.isAnonymous) {
        await currentUser.linkWithCredential(credential);
      } else {
        await FirebaseAuth.instance.signInWithCredential(credential);
      }
      state = _firebaseAuth.currentUser;
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> loginWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      OAuthProvider oauthProvider = OAuthProvider('apple.com');
      final credential = oauthProvider.credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      state = _firebaseAuth.currentUser;
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}
