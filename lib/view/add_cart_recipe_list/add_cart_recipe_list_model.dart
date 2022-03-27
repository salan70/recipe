import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipe/domain/cart.dart';

import '../../repository/cart_repository.dart';

class AddCartRecipeListModel extends ChangeNotifier {
  AddCartRecipeListModel({required this.user});
  final User user;

  bool checkCart(List<RecipeListInCart> recipeForInCartList) {
    bool zeroIsInclude = false;

    for (var recipeForInCart in recipeForInCartList)
      if (recipeForInCart.countInCart == 0) {
        zeroIsInclude = true;
      }

    return zeroIsInclude;
  }

  Future<bool> updateCountsInCart(
      List<RecipeListInCart> recipeForInCartList) async {
    CartRepository cartRepository = CartRepository(user: user);

    print('in updateCountsInCart');

    bool updateIsSuccess = true;

    for (var recipeForInCart in recipeForInCartList) {
      try {
        cartRepository.updateCount(
            recipeForInCart.recipeId!, recipeForInCart.countInCart!);
      } catch (e) {
        updateIsSuccess = false;
        print('${recipeForInCart.recipeId} でエラー: $e');
      }
    }

    return updateIsSuccess;
  }
}
