import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe/domain/cart.dart';
import 'package:recipe/domain/recipe.dart';
import 'package:recipe/repository/firebase/cart_repository.dart';
import 'package:recipe/repository/firebase/recipe_repository.dart';
import 'package:recipe/state/auth/auth_provider.dart';
import 'package:recipe/state/recipe_in_cart/recipe_in_cart_list_state.dart';

final recipeListStreamProvider =
    StreamProvider.autoDispose<List<Recipe>>((ref) {
  final user = ref.watch(userStateNotifierProvider);

  final recipeRepository = RecipeRepository(user: user!);

  return recipeRepository.fetchRecipeList();
});

final recipeStreamProviderFamily =
    StreamProvider.family.autoDispose<Recipe, String>((ref, recipeId) {
  final user = ref.watch(userStateNotifierProvider);

  final recipeRepository = RecipeRepository(user: user!);

  return recipeRepository.fetchRecipe(recipeId);
});

/// search
final searchFunctionProvider = StateProvider.autoDispose((ref) => false);

final recipeAndIngredientNameListStreamProvider =
    StreamProvider.autoDispose<List<RecipeAndIngredientName>>((ref) {
  final user = ref.watch(userStateNotifierProvider);

  final recipeRepository = RecipeRepository(user: user!);

  return recipeRepository.fetchRecipeNameAndIngredientNameList();
});

final searchResultRecipeIdListProvider =
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

final recipeListInCartStreamProvider =
    StreamProvider.autoDispose<List<RecipeListInCart>>((ref) {
  final user = ref.watch(userStateNotifierProvider);
  final cartRepository = CartRepository(user: user!);

  return cartRepository.fetchRecipeListInCart();
});

final recipeForInCartListNotifierProvider = StateNotifierProvider.autoDispose<
    RecipeForInCartListNotifier, List<RecipeListInCart>>(
  (ref) => RecipeForInCartListNotifier(),
);

final stateIsChangedProvider = StateProvider.autoDispose((ref) => false);

final notBuyIngredientListIsOpenProvider =
    StateProvider.autoDispose((ref) => false);

// page_control
final selectPageProvider = StateProvider.autoDispose((ref) => 0);

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
