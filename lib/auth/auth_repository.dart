import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:recipe/components/providers.dart';

import 'custom_exception.dart';

// 抽象クラスを定義
abstract class BaseAuthRepository {
  // ログイン状態の確認用（ログイン状態の変更や初期化時にイベントする）
  Stream<User?> get authStateChanges;

  // サインイン（著名ユーザを作成）
  Future<void> signInAnonymously();
  // 現在サインインしているユーザを取得する。
  User? getCurrentUser();
  // ログアウト
  Future<void> signOut();
}

// AuthRepositoryを提供し、ref.readを渡してアクセスできるようにする
final authRepositoryProvider =
    Provider<AuthRepository>((ref) => AuthRepository(ref.read));

// 認証リポジトリクラス
class AuthRepository implements BaseAuthRepository {
  // riverpod Reader
  // アプリ内の他のプロバイダーを読み取ることを許可
  final Reader _read;

  const AuthRepository(this._read);

  // Readerを利用して、firebaseAuth.instanceにアクセス
  @override
  Stream<User?> get authStateChanges =>
      _read(firebaseAuthProvider).authStateChanges();

  // 匿名ユーザでログイン
  @override
  Future<void> signInAnonymously() async {
    try {
      await _read(firebaseAuthProvider).signInAnonymously();
    } on FirebaseAuthException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  // 既存の匿名ユーザを返却
  @override
  User? getCurrentUser() {
    try {
      return _read(firebaseAuthProvider).currentUser;
    } on FirebaseAuthException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  // サインアウトしたら、新たに匿名ユーザでログインさせる。
  @override
  Future<void> signOut() async {
    try {
      // サインアウト
      await _read(firebaseAuthProvider).signOut();
      // 匿名でサインイン
      await signInAnonymously();
    } on FirebaseAuthException catch (e) {
      throw CustomException(message: e.message);
    }
  }
}
