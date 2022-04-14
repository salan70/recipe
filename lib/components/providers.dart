import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe/domain/cart.dart';
import 'package:recipe/repository/firebase/cart_repository.dart';
import 'package:recipe/repository/firebase/recipe_repository.dart';
import 'package:recipe/state/recipe_stream_state.dart';
import 'package:recipe/domain/recipe.dart';
import 'package:recipe/components/widgets/reordable_text_field/procedures.dart';
import 'package:recipe/components/widgets/reordable_text_field/ingredient_text_field/ingredient_text_field_widget.dart';
import 'package:recipe/auth/auth_controller.dart';
import 'package:recipe/state/image_file_state.dart';
import 'package:recipe/state/recipe_in_cart_list_state.dart';

final authControllerProvider = StateNotifierProvider<AuthController, User?>(
  (ref) => AuthController(ref.read)..appStarted(),
);

final imageFileNotifierProvider =
    StateNotifierProvider.autoDispose<ImageFileNotifier, File?>((ref) {
  return ImageFileNotifier();
});

// 匿名認証用?
final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final passwordIsObscureProvider = StateProvider.autoDispose((ref) => true);

final emailProvider = StateProvider.autoDispose((ref) => '');

final passwordProvider = StateProvider.autoDispose((ref) => '');

final recipeListStreamProvider =
    StreamProvider.autoDispose<List<Recipe>>((ref) {
  final user = ref.watch(authControllerProvider);

  RecipeRepository recipeRepository = RecipeRepository(user: user!);

  return recipeRepository.fetchRecipeList();
});

final ingredientListStreamProviderFamily = StreamProvider.family
    .autoDispose<List<Ingredient>, String>((ref, recipeId) {
  final user = ref.watch(authControllerProvider);

  RecipeRepository recipeRepository = RecipeRepository(user: user!);

  return recipeRepository.fetchIngredientList(recipeId);
});

final procedureListStreamProviderFamily =
    StreamProvider.family.autoDispose<List<Procedure>, String>((ref, recipeId) {
  final user = ref.watch(authControllerProvider);

  RecipeRepository recipeRepository = RecipeRepository(user: user!);

  return recipeRepository.fetchProcedureList(recipeId);
});

final recipeStreamProviderFamily =
    StreamProvider.family.autoDispose<Recipe, String>((ref, recipeId) {
  final user = ref.watch(authControllerProvider);

  RecipeRepository recipeRepository = RecipeRepository(user: user!);

  return recipeRepository.fetchRecipe(recipeId);
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
  final user = ref.watch(authControllerProvider);
  CartRepository cartRepository = CartRepository(user: user!);

  return cartRepository.fetchRecipeListInCart();
});

final recipeForInCartListNotifierProvider = StateNotifierProvider.autoDispose<
    RecipeForInCartListNotifier, List<RecipeListInCart>>(
  (ref) => RecipeForInCartListNotifier(),
);

final stateIsChangedProvider = StateProvider.autoDispose((ref) => false);

// page_control
final selectPageProvider = StateProvider.autoDispose((ref) => 0);
