import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe/domain/recipe.dart';
import 'package:recipe/repository/firebase/user_repository.dart';

// class SignUpModel extends ChangeNotifier {
//   UserRepository authRepository = UserRepository();
//
//   Future signUp(String email, String password) async {
//     final user = await authRepository.signUp(email, password);
//     authRepository.addUser(user);
//
//     print('登録完了');
//   }
// }
