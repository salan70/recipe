import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe/domain/cart.dart';
import 'package:recipe/repository/cart_repository.dart';

class AddCartRecipeDetailModel extends ChangeNotifier {
  AddCartRecipeDetailModel({required this.user});
  final User user;

  Future addOrUpdateRecipe(
      String? inCartRecipeId, String recipeId, int count) async {
    CartRepository cartRepository = CartRepository(user: user);

    if (count != 0) {
      if (inCartRecipeId != null) {
        try {
          await cartRepository.updateRecipe(count, inCartRecipeId);
        } catch (e) {
          print('cartRepository.update 失敗:$e');
        }
      } else {
        try {
          await cartRepository.addRecipe(count, recipeId);
        } catch (e) {
          print('cartRepository.add 失敗:$e');
        }
      }
    } else {
      if (inCartRecipeId != null) {
        try {
          await cartRepository.deleteRecipe(inCartRecipeId);
          print('delete完了');
        } catch (e) {
          print('cartRepository.delete 失敗:$e');
        }
      }
    }
  }
}
