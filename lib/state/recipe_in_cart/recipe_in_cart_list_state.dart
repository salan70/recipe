import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:recipe/domain/cart.dart';

class RecipeForInCartListNotifier
    extends StateNotifier<List<RecipeListInCart>> {
  RecipeForInCartListNotifier() : super([]);

  void delete(String id) {}

  void increase(String recipeId) {
    state = [
      for (final recipeForInCart in state)
        if (recipeForInCart.recipeId == recipeId)
          recipeForInCart.copyWith(
              countInCart: recipeForInCart.countInCart! + 1)
        else
          recipeForInCart,
    ];
  }

  void decrease(String recipeId) {
    state = [
      for (final recipeForInCart in state)
        if (recipeForInCart.recipeId == recipeId)
          recipeForInCart.copyWith(
              countInCart: recipeForInCart.countInCart! - 1)
        else
          recipeForInCart,
    ];
  }

  List<RecipeListInCart> getList(List<RecipeListInCart> recipeForInCartList) {
    return state = recipeForInCartList;
  }

  int calculateCountSum() {
    int countSum = 0;

    for (var recipeForInCart in state) countSum += recipeForInCart.countInCart!;

    return countSum;
  }
}
