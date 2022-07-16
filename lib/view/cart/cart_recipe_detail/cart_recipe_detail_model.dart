import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipe/repository/firebase/cart_repository.dart';

class AddCartRecipeDetailModel extends ChangeNotifier {
  AddCartRecipeDetailModel({required this.user});
  final User user;

  Future<String?> updateCount(String recipeId, int count) async {
    final cartRepository = CartRepository(user: user);

    try {
      await cartRepository.updateCount(recipeId, count);
      return null;
    } on Exception catch (e) {
      return e.toString();
    }
  }
}
