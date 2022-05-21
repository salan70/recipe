import 'package:firebase_auth/firebase_auth.dart';

class AuthException {
  String outputAuthErrorText(FirebaseAuthException e) {
    switch (e.code) {

      /// signup
      // email
      case 'invalid-email':
        return 'メールアドレスが不正です。';

      case 'weak-password':
        return 'パスワードは6文字以上で入力してください';

      case 'email-already-in-use':
        return 'このメールアドレスはすでに登録されています。';

      /// login
      // common
      case 'wrong-password':
        return 'メールアドレスもしくはパスワードが正しくありません。';

      case 'user-not-found':
        return 'メールアドレスもしくはパスワードが正しくありません。';

      // google/apple
      case 'credential-already-in-use':
        return 'このアカウントは既に登録されています。';

      /// reAuth
      case 'user-mismatch':
        return 'アカウントが異なります。\nログインされているアカウントで再認証を行ってください。';

      /// other
      case 'user-disabled':
        return 'このメールアドレスは無効になっています。';

      case 'too-many-requests':
        return '回線が混雑しています。もう一度試してみてください。';

      case 'operation-not-allowed':
        return 'メールアドレスとパスワードでのログインは有効になっていません。';

      default:
        return '予期せぬエラーが発生しました。';
    }
  }
}
