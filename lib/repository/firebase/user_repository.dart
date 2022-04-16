import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// 認証系の処理
class UserRepository {
  /// auth関係
  Future fetchCurrentUser() async {}

  Future<User> login(String email, String password) async {
    UserCredential firebaseUser =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    print("ログイン成功");
    return firebaseUser.user!;
  }

  Future<User> signUp(String email, String password) async {
    final firebaseUser =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return firebaseUser.user!;
  }

  /// その他
  Future addUser(User user) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('user_info')
        .add({
      'email': user.email,
      'createdAt': DateTime.now(),
    });
  }
}
