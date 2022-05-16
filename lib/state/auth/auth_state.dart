import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:recipe/repository/hive/cart_item_repository.dart';
import 'package:recipe/repository/hive/ingredient_unit_repository.dart';
import 'package:recipe/repository/hive/customizations_repository.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:recipe/repository/firebase/user_repository.dart';

class AuthStateNotifier extends StateNotifier<User?> {
  AuthStateNotifier() : super(null);

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  UserRepository _userRepository = UserRepository();

  ///TODO login時、userInfoをfireStoreに保存する

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
    await _deleteAllHiveBoxes();
    state = firebaseAuth.currentUser;
  }

  // すべてのhiveのboxを削除
  Future _deleteAllHiveBoxes() async {
    CartItemRepository cartItemRepository = CartItemRepository();
    IngredientUnitRepository ingredientUnitRepository =
        IngredientUnitRepository();
    CustomizationsRepository selectedSchemeColorRepository =
        CustomizationsRepository();

    await cartItemRepository.deleteAllCartItem();
    await ingredientUnitRepository.deleteIngredientUnitList();
    await selectedSchemeColorRepository.deleteSelectedFlexScheme();
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
        await _userRepository.addUser(state!);
        print(state!.email.toString());
        return null;
      }
      // このelseには行かない想定
      else {
        return 'サインアップ失敗';
      }
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
      await _deleteAllHiveBoxes();
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
        state = _firebaseAuth.currentUser;
        await _userRepository.addUser(state!);
        print('a');
        return null;
      }
      // このelseは行かない想定
      else {
        return 'サインアップ失敗';
      }
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
      await _deleteAllHiveBoxes();
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
        state = _firebaseAuth.currentUser;
        await _userRepository.addUser(state!);
        return null;
      }
      // このelseは行かない想定
      else {
        return 'サインアップ失敗';
      }
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
      await _deleteAllHiveBoxes();
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}
