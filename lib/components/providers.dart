import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe/domain/cart.dart';
import 'package:recipe/repository/firebase/cart_repository.dart';
import 'package:recipe/repository/firebase/recipe_repository.dart';
import 'package:recipe/state/auth/auth_provider.dart';
import 'package:recipe/state/recipe/recipe_stream_state.dart';
import 'package:recipe/domain/recipe.dart';
import 'package:recipe/components/widgets/reordable_text_field/procedures.dart';
import 'package:recipe/components/widgets/reordable_text_field/ingredient_text_field/ingredient_text_field_widget.dart';
import 'package:recipe/state/image_file/image_file_state.dart';
import 'package:recipe/state/recipe_in_cart/recipe_in_cart_list_state.dart';

final imageFileNotifierProvider =
    StateNotifierProvider.autoDispose<ImageFileNotifier, File?>((ref) {
  return ImageFileNotifier();
});

final recipeListStreamProvider =
    StreamProvider.autoDispose<List<Recipe>>((ref) {
  final user = ref.watch(userStateNotifierProvider);

  RecipeRepository recipeRepository = RecipeRepository(user: user!);

  return recipeRepository.fetchRecipeList();
});

final recipeStreamProviderFamily =
    StreamProvider.family.autoDispose<Recipe, String>((ref, recipeId) {
  final user = ref.watch(userStateNotifierProvider);

  RecipeRepository recipeRepository = RecipeRepository(user: user!);

  return recipeRepository.fetchRecipe(recipeId);
});

/// search
final searchFunctionProvider = StateProvider.autoDispose((ref) => false);

final recipeAndIngredientNameListStreamProvider =
    StreamProvider.autoDispose<List<RecipeAndIngredientName>>((ref) {
  final user = ref.watch(userStateNotifierProvider);

  RecipeRepository recipeRepository = RecipeRepository(user: user!);

  return recipeRepository.fetchRecipeNameAndIngredientNameList();
});

final searchResultRecipeIdListProvider =
    StateProvider.autoDispose<List<String>?>((ref) {
  return null;
});

/// reordarale_text_field
final ingredientListNotifierProvider =
    StateNotifierProvider.autoDispose<IngredientListNotifier, List<Ingredient>>(
  (ref) => IngredientListNotifier(),
);

final procedureListNotifierProvider =
    StateNotifierProvider.autoDispose<ProcedureListNotifier, List<Procedure>>(
  (ref) => ProcedureListNotifier(),
);

// ingredient
final nameIsChangedProvider = StateProvider.autoDispose((ref) => false);
final amountIsChangedProvider = StateProvider.autoDispose((ref) => false);
// procedure
final contentIsChangedProvider = StateProvider.autoDispose((ref) => false);

/// cart
final recipeNumCountProviderFamily =
    StateProvider.family.autoDispose<int, int?>((count, initialCount) {
  int count = 1;

  if (initialCount != null && initialCount != 0) {
    count = initialCount;
  }
  return count;
});

final recipeListInCartStreamProvider =
    StreamProvider.autoDispose<List<RecipeListInCart>>((ref) {
  final user = ref.watch(userStateNotifierProvider);
  CartRepository cartRepository = CartRepository(user: user!);

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
