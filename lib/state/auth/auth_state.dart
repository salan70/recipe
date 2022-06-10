import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:recipe/components/auth_exception.dart';
import 'package:recipe/domain/re_auth.dart';
import 'package:recipe/repository/firebase/recipe_repository.dart';
import 'package:recipe/repository/firebase/user_repository.dart';
import 'package:recipe/repository/hive/cart_item_repository.dart';
import 'package:recipe/repository/hive/customizations_repository.dart';
import 'package:recipe/repository/hive/ingredient_unit_repository.dart';
import 'package:recipe/state/other_provider/providers.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthStateNotifier extends StateNotifier<User?> {
  AuthStateNotifier() : super(null);

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final UserRepository _userRepository = UserRepository();

  // アプリ開始
  Future<void> appStarted() async {
    if (_firebaseAuth.currentUser == null) {
      await _firebaseAuth.signInAnonymously();
    }
    state = _firebaseAuth.currentUser;
  }

  void authStateUpdate() {
    state = _firebaseAuth.currentUser;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _deleteAllHiveBoxes();
    await _firebaseAuth.signInAnonymously();
    state = _firebaseAuth.currentUser;
  }

  // 現在ログインしているユーザーの認証方法を返す
  String? fetchProviderId() {
    try {
      return _firebaseAuth.currentUser!.providerData[0].providerId;
    } on Exception {
      return null;
    }
  }

  String fetchEmail() {
    return _firebaseAuth.currentUser!.providerData[0].email!;
  }

  Future<String?> deleteUser(WidgetRef ref, AuthCredential? credential) async {
    // 匿名ユーザー以外は再認証時のcredentialでreAuthする
    if (credential != null) {
      try {
        await _firebaseAuth.currentUser!
            .reauthenticateWithCredential(credential);
      } on FirebaseAuthException catch (e) {
        final authException = AuthException();

        return authException.outputAuthErrorText(e);
      }
    }

    final deleteErrorText = await _deleteAllUserInfo(ref);
    if (deleteErrorText != null) {
      return deleteErrorText;
    }

    // deleteしたuserの情報をFireStoreに保存
    await _userRepository.addDeletedUserInfo(_firebaseAuth.currentUser!);

    // firebaseAuthでuserを削除
    await _firebaseAuth.currentUser!.delete();

    // 新たに匿名ログイン
    await _firebaseAuth.signInAnonymously();
    state = _firebaseAuth.currentUser;

    return null;
  }

  Future<String?> _deleteAllUserInfo(WidgetRef ref) async {
    final recipeListStream = ref.watch(recipeListProvider);
    final recipeRepository = RecipeRepository(user: _firebaseAuth.currentUser!);

    // 全てのrecipeを削除
    recipeListStream.when(
      error: (error, stack) {
        return error.toString();
      },
      loading: () {},
      data: (recipeList) async {
        for (final recipe in recipeList) {
          try {
            if (recipe.imageUrl != '') {
              await recipeRepository.deleteImage(recipe);
            }
            await recipeRepository.deleteRecipe(recipe);
          } on Exception catch (e) {
            return e.toString();
          }
        }
      },
    );
    // userInfoを削除
    await _userRepository.deleteUserInfo(_firebaseAuth.currentUser!);
    // hiveを削除
    await _deleteAllHiveBoxes();

    return null;
  }

  // すべてのhiveのboxを削除
  Future<void> _deleteAllHiveBoxes() async {
    final cartItemRepository = CartItemRepository();
    final ingredientUnitRepository = IngredientUnitRepository();
    final selectedSchemeColorRepository = CustomizationsRepository();

    await cartItemRepository.deleteAllCartItem();
    await ingredientUnitRepository.deleteIngredientUnitList();
    await selectedSchemeColorRepository.deleteSelectedFlexScheme();
    await selectedSchemeColorRepository.deleteSelectedThemeModeIndex();
  }

  /// Email
  Future<String?> signUpWithEmail(String email, String password) async {
    final currentUser = _firebaseAuth.currentUser;
    try {
      final credential =
          EmailAuthProvider.credential(email: email, password: password);
      // 匿名アカウントとのリンク
      if (currentUser!.isAnonymous) {
        await currentUser.linkWithCredential(credential);
        state = _firebaseAuth.currentUser;
        await _userRepository.addUserInfo(state!);
        return null;
      }
      // このelseには行かない想定
      else {
        return 'サインアップ失敗';
      }
    } on FirebaseAuthException catch (e) {
      final authException = AuthException();

      return authException.outputAuthErrorText(e);
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
    } on FirebaseAuthException catch (e) {
      final authException = AuthException();

      return authException.outputAuthErrorText(e);
    }
  }

  /// Google Account
  Future<String?> signUpWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    final googleAuth = await googleUser!.authentication;
    final currentUser = _firebaseAuth.currentUser;

    try {
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      if (currentUser!.isAnonymous) {
        await currentUser.linkWithCredential(credential);
        state = _firebaseAuth.currentUser;
        await _userRepository.addUserInfo(state!);
        return null;
      }
      // このelseは行かない想定
      else {
        return 'サインアップ失敗';
      }
    } on FirebaseAuthException catch (e) {
      final authException = AuthException();

      return authException.outputAuthErrorText(e);
    }
  }

  Future<String?> loginWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    final googleAuth = await googleUser!.authentication;

    try {
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final loginUser =
          await FirebaseAuth.instance.signInWithCredential(credential);
      state = _firebaseAuth.currentUser;

      // 初回ログインの場合、userInfoをFireStoreに保存
      if (loginUser.additionalUserInfo!.isNewUser) {
        await _userRepository.addUserInfo(state!);
      }

      await _deleteAllHiveBoxes();
      return null;
    } on FirebaseAuthException catch (e) {
      final authException = AuthException();

      return authException.outputAuthErrorText(e);
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
      final oauthProvider = OAuthProvider('apple.com');
      final credential = oauthProvider.credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      if (currentUser!.isAnonymous) {
        await currentUser.linkWithCredential(credential);
        state = _firebaseAuth.currentUser;
        await _userRepository.addUserInfo(state!);
        return null;
      }
      // このelseは行かない想定
      else {
        return 'サインアップ失敗';
      }
    } on FirebaseAuthException catch (e) {
      final authException = AuthException();

      return authException.outputAuthErrorText(e);
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
      final oauthProvider = OAuthProvider('apple.com');
      final credential = oauthProvider.credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      final loginUser =
          await FirebaseAuth.instance.signInWithCredential(credential);
      state = _firebaseAuth.currentUser;

      if (loginUser.additionalUserInfo!.isNewUser) {
        await _userRepository.addUserInfo(state!);
      }

      await _deleteAllHiveBoxes();
      return null;
    } on FirebaseAuthException catch (e) {
      final authException = AuthException();

      return authException.outputAuthErrorText(e);
    }
  }

  /// reAuth (退会するために必要)
  Future<ReAuth> reAuthWithEmail(
    WidgetRef ref,
    String email,
    String password,
  ) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      return ReAuth(null, credential);
    } on FirebaseAuthException catch (e) {
      final authException = AuthException();

      return ReAuth(authException.outputAuthErrorText(e), null);
    }
  }

  Future<ReAuth> reAuthWithGoogle(WidgetRef ref) async {
    final googleUser = await GoogleSignIn().signIn();
    final googleAuth = await googleUser!.authentication;

    try {
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return ReAuth(null, credential);
    } on FirebaseAuthException catch (e) {
      final authException = AuthException();

      return ReAuth(authException.outputAuthErrorText(e), null);
    }
  }

  Future<ReAuth> reAuthWithApple(WidgetRef ref) async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final oauthProvider = OAuthProvider('apple.com');
      final credential = oauthProvider.credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      return ReAuth(null, credential);
    } on FirebaseAuthException catch (e) {
      final authException = AuthException();

      return ReAuth(authException.outputAuthErrorText(e), null);
    }
  }
}
