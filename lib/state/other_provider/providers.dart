import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/buy_list.dart';
import '../../domain/recipe.dart';
import '../../repository/firebase/cart_repository.dart';
import '../../repository/firebase/recipe_repository.dart';
import '../auth/auth_provider.dart';

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

final searchWordProvider =
    StateProvider.autoDispose((ref) => TextEditingController());

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
final selectedCountProvider = StateProvider.autoDispose((ref) => '');

// TODO RecipeInCartをRecipeにできないか検討する
final recipeListInCartProvider =
    StreamProvider.autoDispose<List<RecipeInCart>>((ref) {
  final user = ref.watch(userStateNotifierProvider);
  final cartRepository = CartRepository(user: user!);

  return cartRepository.fetchRecipeListInCart();
});

final otherBuyListItemListProvider =
    StreamProvider.autoDispose<List<OtherBuyListItem>>((ref) {
  final user = ref.watch(userStateNotifierProvider);
  final cartRepository = CartRepository(user: user!);

  return cartRepository.fetchOtherBuyListItemList();
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
