import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipe/domain/cart.dart';

import '../../../../repository/firebase/cart_repository.dart';

class CartListModel extends ChangeNotifier {
  CartListModel({required this.user});
  final User user;
  final countList =
      List<String>.generate(99, (index) => (index + 1).toString());

  Future<String?> updateCountInCart(RecipeInCart recipe) async {
    final cartRepository = CartRepository(user: user);

    try {
      await cartRepository.updateCount(
        recipe.recipeId!,
        recipe.countInCart!,
      );
    } on Exception catch (e) {
      return e.toString();
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
