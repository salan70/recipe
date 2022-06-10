import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  /// auth関係
  Future<User> login(String email, String password) async {
    final firebaseUser = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
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
  Future<void> addUserInfo(User user) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set(<String, dynamic>{
      'email': user.email,
      'createdAt': DateTime.now(),
    });
  }

  Future<void> addDeletedUserInfo(User user) async {
    await FirebaseFirestore.instance
        .collection('deletedUsers')
        .doc(user.uid)
        .set(<String, dynamic>{
      'deletedAt': DateTime.now(),
    });
  }

  Future<void> deleteUserInfo(User user) async {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();
  }
}
