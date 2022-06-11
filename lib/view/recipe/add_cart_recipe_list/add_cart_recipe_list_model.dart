import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipe/domain/cart.dart';

import '../../../repository/firebase/cart_repository.dart';

class AddCartRecipeListModel extends ChangeNotifier {
  AddCartRecipeListModel({required this.user});
  final User user;

  bool zeroIsIncludeInCart(List<RecipeInCart> recipeForInCartList) {
    var zeroIsInclude = false;

    for (final recipeForInCart in recipeForInCartList) {
      if (recipeForInCart.countInCart == 0) {
        zeroIsInclude = true;
      }
    }

    return zeroIsInclude;
  }

  Future<String?> updateCountsInCart(
    List<RecipeInCart> recipeForInCartList,
  ) async {
    final cartRepository = CartRepository(user: user);

    for (final recipeForInCart in recipeForInCartList) {
      try {
        await cartRepository.updateCount(
          recipeForInCart.recipeId!,
          recipeForInCart.countInCart!,
        );
      } on Exception catch (e) {
        return e.toString();
      }
    }
    return null;
  }

  Future<String?> deleteAllRecipeFromCart(
    List<RecipeInCart> recipeForInCartList,
  ) async {
    final cartRepository = CartRepository(user: user);

    for (final recipeForInCart in recipeForInCartList) {
      try {
        await cartRepository.updateCount(recipeForInCart.recipeId!, 0);
      } on Exception catch (e) {
        return e.toString();
      }
    }
    return null;
  }
}
