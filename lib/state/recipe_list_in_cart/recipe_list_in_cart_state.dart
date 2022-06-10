import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe/domain/cart.dart';

class RecipeListInCartNotifier extends StateNotifier<List<RecipeListInCart>> {
  RecipeListInCartNotifier() : super([]);

  void delete(String id) {}

  void increase(String recipeId) {
    state = [
      for (final recipeForInCart in state)
        if (recipeForInCart.recipeId == recipeId)
          recipeForInCart.copyWith(
            countInCart: recipeForInCart.countInCart! + 1,
          )
        else
          recipeForInCart,
    ];
  }

  void decrease(String recipeId) {
    state = [
      for (final recipeForInCart in state)
        if (recipeForInCart.recipeId == recipeId)
          recipeForInCart.copyWith(
            countInCart: recipeForInCart.countInCart! - 1,
          )
        else
          recipeForInCart,
    ];
  }

  List<RecipeListInCart> getList(List<RecipeListInCart> recipeForInCartList) {
    return state = recipeForInCartList;
  }

  int calculateSum() {
    var countSum = 0;
    for (final recipeForInCart in state) {
      countSum += recipeForInCart.countInCart!;
    }
    return countSum;
  }
}
