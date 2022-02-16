import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'auth_repository.dart';
import 'package:recipe/providers.dart';

class AuthController extends StateNotifier<User?> {
  final Reader _read;

  StreamSubscription<User?>? _authStateChangesSubscription;

  AuthController(this._read) : super(null) {
    // 受信停止
    _authStateChangesSubscription?.cancel();
    // 受信開始
    _authStateChangesSubscription = _read(authRepositoryProvider)
        .authStateChanges
        .listen((user) => state = user);
  }

  // 不要な受信をキャンセルするためにdisposeでキャンセルする
  @override
  void dispose() {
    _authStateChangesSubscription?.cancel();
    super.dispose();
  }

  // アプリ開始
  void appStarted() async {
    // Currentユーザを取得
    final user = _read(authRepositoryProvider).getCurrentUser();
    print(user);
    // ログインされていなければ、匿名でサインインしてログインさせる。
    if (user == null) {
      await _read(authRepositoryProvider).signInAnonymously();
      print('新たに匿名でサインイン');
    }
  }

  // サインアウト
  void signOut() async {
    // サインアウトメソッド
    await _read(authRepositoryProvider).signOut();
  }

  // ユーザー削除
  Future<void> userDelete(User user) async {
    await user.delete();
  }
}
