import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe/view/add_recipe/add_redipe_model.dart';
import 'domain/recipe.dart';
import 'package:recipe/parts/reordable_text_field/procedures.dart';
import 'package:recipe/parts/reordable_text_field/ingredients.dart';
// import 'package:photoapp/photo.dart';
// import 'package:photoapp/

final recipeListNotifierProvider =
    StateNotifierProvider.autoDispose<RecipeListNotifier, List<Recipe>>((ref) {
  return RecipeListNotifier();
});

// 匿名認証用?
final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final ingredientListNotifierProvider =
    StateNotifierProvider.autoDispose<IngredientListNotifier, List<Ingredient>>(
  (ref) => IngredientListNotifier(),
);

final procedureListNotifierProvider =
    StateNotifierProvider.autoDispose<ProcedureListNotifier, List<Procedure>>(
  (ref) => ProcedureListNotifier(),
);
