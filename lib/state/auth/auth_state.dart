import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:recipe/components/providers.dart';
import 'package:recipe/domain/re_auth.dart';
import 'package:recipe/repository/firebase/recipe_repository.dart';
import 'package:recipe/repository/hive/cart_item_repository.dart';
import 'package:recipe/repository/hive/ingredient_unit_repository.dart';
import 'package:recipe/repository/hive/customizations_repository.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:recipe/repository/firebase/user_repository.dart';

///TODO login時、userInfoをfireStoreに保存する
class AuthStateNotifier extends StateNotifier<User?> {
  AuthStateNotifier() : super(null);

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  UserRepository _userRepository = UserRepository();

  // アプリ開始
  Future appStarted() async {
    if (_firebaseAuth.currentUser == null) {
      await _firebaseAuth.signInAnonymously();
    }
    state = _firebaseAuth.currentUser;
  }

  void authStateUpdate() {
    state = _firebaseAuth.currentUser;
  }

  Future signOut() async {
    await _firebaseAuth.signOut();
    await _deleteAllHiveBoxes();
    await _firebaseAuth.signInAnonymously();
    state = _firebaseAuth.currentUser;
  }

  // 現在ログインしているユーザーの認証方法を返す
  String? fetchProviderId() {
    try {
      final userInfo = _firebaseAuth.currentUser!.providerData[0];
      return _firebaseAuth.currentUser!.providerData[0].providerId;
    } catch (e) {
      return null;
    }
  }

  String fetchEmail() {
    return _firebaseAuth.currentUser!.providerData[0].email!;
  }

  Future<ReAuth> reAuthWithEmail(
      WidgetRef ref, String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      print('ok $credential');
      return ReAuth(null, credential);
    } catch (e) {
      print(e);
      return ReAuth(e.toString(), null);
    }
  }

  Future<String?> deleteUser(WidgetRef ref, AuthCredential credential) async {
    await _firebaseAuth.currentUser!.reauthenticateWithCredential(credential);

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
    final recipeListStream = ref.watch(recipeListStreamProvider);
    RecipeRepository recipeRepository =
        RecipeRepository(user: _firebaseAuth.currentUser!);

    // 全てのrecipeを削除
    recipeListStream.when(
        error: (error, stack) {
          return error.toString();
        },
        loading: () {},
        data: (recipeList) async {
          for (var recipe in recipeList)
            try {
              if (recipe.imageUrl != '') {
                await recipeRepository.deleteImage(recipe);
              }
              await recipeRepository.deleteRecipe(recipe);
            } catch (e) {
              return e.toString();
            }
        });
    // userInfoを削除
    await _userRepository.deleteUserInfo(_firebaseAuth.currentUser!);
    // hiveを削除
    await _deleteAllHiveBoxes();

    return null;
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
        await _userRepository.addUserInfo(state!);
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
        await _userRepository.addUserInfo(state!);
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
        await _userRepository.addUserInfo(state!);
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
