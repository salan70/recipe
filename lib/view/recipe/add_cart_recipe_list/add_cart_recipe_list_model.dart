import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipe/domain/cart.dart';

import '../../../repository/firebase/cart_repository.dart';

class AddCartRecipeListModel extends ChangeNotifier {
  AddCartRecipeListModel({required this.user});
  final User user;

  bool zeroIsIncludeInCart(List<RecipeListInCart> recipeForInCartList) {
    bool zeroIsInclude = false;

    for (var recipeForInCart in recipeForInCartList)
      if (recipeForInCart.countInCart == 0) {
        zeroIsInclude = true;
      }

    return zeroIsInclude;
  }

  Future<String?> updateCountsInCart(
      List<RecipeListInCart> recipeForInCartList) async {
    CartRepository cartRepository = CartRepository(user: user);

    for (var recipeForInCart in recipeForInCartList) {
      try {
        cartRepository.updateCount(
            recipeForInCart.recipeId!, recipeForInCart.countInCart!);
      } catch (e) {
        return e.toString();
      }
    }
    return null;
  }

  Future<String?> deleteAllRecipeFromCart(
      List<RecipeListInCart> recipeForInCartList) async {
    CartRepository cartRepository = CartRepository(user: user);

    for (var recipeForInCart in recipeForInCartList) {
      try {
        cartRepository.updateCount(recipeForInCart.recipeId!, 0);
      } catch (e) {
        return e.toString();
      }
    }
    return null;
  }
}
