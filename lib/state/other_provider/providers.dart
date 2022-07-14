import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe/domain/cart.dart';
import 'package:recipe/domain/recipe.dart';
import 'package:recipe/repository/firebase/cart_repository.dart';
import 'package:recipe/repository/firebase/recipe_repository.dart';
import 'package:recipe/state/auth/auth_provider.dart';
import 'package:recipe/state/recipe_list_in_cart/recipe_list_in_cart_state.dart';

final recipeListProvider = StreamProvider.autoDispose<List<Recipe>>((ref) {
  final user = ref.watch(userStateNotifierProvider);

  final recipeRepository = RecipeRepository(user: user!);

  return recipeRepository.fetchRecipeList();
});

final recipeProviderFamily =
    StreamProvider.family.autoDispose<Recipe, String>((ref, recipeId) {
  final user = ref.watch(userStateNotifierProvider);

  final recipeRepository = RecipeRepository(user: user!);

  return recipeRepository.fetchRecipe(recipeId);
});

/// search
final isEnteringProvider = StateProvider.autoDispose((ref) => true);

final isFirstEnterProvider = StateProvider.autoDispose((ref) => true);

final isFirstSearchProvider = StateProvider.autoDispose((ref) => true);

final recipeAndIngredientListProvider =
    StreamProvider.autoDispose<List<RecipeAndIngredient>>((ref) {
  final user = ref.watch(userStateNotifierProvider);

  final recipeRepository = RecipeRepository(user: user!);

  return recipeRepository.fetchRecipeNameAndIngredientNameList();
});

final searchResultListProvider =
    StateProvider.autoDispose<List<String>?>((ref) {
  return null;
});

// ingredient
final nameIsChangedProvider = StateProvider.autoDispose((ref) => false);
final amountIsChangedProvider = StateProvider.autoDispose((ref) => false);
// procedure
final contentIsChangedProvider = StateProvider.autoDispose((ref) => false);

/// cart
final recipeNumCountProviderFamily =
    StateProvider.family.autoDispose<int, int?>((count, initialCount) {
  var count = 1;

  if (initialCount != null && initialCount != 0) {
    count = initialCount;
  }
  return count;
});

final recipeListInCartPanelIsOpenProvider =
    StateProvider.autoDispose((ref) => false);

final recipeListInCartProvider =
    StreamProvider.autoDispose<List<RecipeInCart>>((ref) {
  final user = ref.watch(userStateNotifierProvider);
  final cartRepository = CartRepository(user: user!);

  return cartRepository.fetchRecipeListInCart();
});

final recipeListInCartNotifierProvider = StateNotifierProvider.autoDispose<
    RecipeListInCartNotifier, List<RecipeInCart>>(
  (ref) => RecipeListInCartNotifier(),
);

final otherCartItemListProvider =
    StreamProvider.autoDispose<List<OtherCartItem>>((ref) {
  final user = ref.watch(userStateNotifierProvider);
  final cartRepository = CartRepository(user: user!);

  return cartRepository.fetchOtherCartItemList();
});

final stateIsChangedProvider = StateProvider.autoDispose((ref) => false);

final notBuyListIsOpenProvider = StateProvider.autoDispose((ref) => false);

final selectedTabContextProvider = StateProvider.autoDispose((ref) {
  BuildContext? context;
  return context;
});

/// setting
final selectedSchemeColorProvider =
    StateProvider.autoDispose<FlexScheme>((ref) {
  return FlexScheme.green;
});

final feedbackProvider = StateProvider.autoDispose<String>((ref) {
  return '';
});

// 汎用
final isLoadingProvider = StateProvider.autoDispose((ref) => false);
