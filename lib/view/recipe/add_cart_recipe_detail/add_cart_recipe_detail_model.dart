import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe/domain/cart.dart';
import 'package:recipe/repository/firebase/cart_repository.dart';

class AddCartRecipeDetailModel extends ChangeNotifier {
  AddCartRecipeDetailModel({required this.user});
  final User user;

  Future updateCount(String recipeId, int count) async {
    CartRepository cartRepository = CartRepository(user: user);

    try {
      await cartRepository.updateCount(recipeId, count);
    } catch (e) {
      print('cartRepository.update 失敗:$e');
    }
  }
}
