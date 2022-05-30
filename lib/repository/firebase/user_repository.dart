import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  /// auth関係
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
  Future addUserInfo(User user) async {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'email': user.email,
      'createdAt': DateTime.now(),
    });
  }

  Future addDeletedUserInfo(User user) async {
    await FirebaseFirestore.instance
        .collection('deletedUsers')
        .doc(user.uid)
        .set({
      'deletedAt': DateTime.now(),
    });
  }

  Future deleteUserInfo(User user) async {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();
  }
}
