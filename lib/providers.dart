import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe/view/add_recipe/add_redipe_model.dart';
import 'domain/recipe.dart';
import 'package:recipe/parts/reordable_text_field/procedures.dart';
// import 'package:photoapp/photo.dart';
// import 'package:photoapp/

final recipeListNotifierProvider =
    StateNotifierProvider<RecipeListNotifier, List<Recipe>>((ref) {
  return RecipeListNotifier();
});

// 匿名認証用?
final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final StateProvider ingredientsDropBoxProvider = StateProvider((ref) {
  return 0;
});

// 料理名の受け渡しを行うためのProvider
// ※ autoDisposeを付けることで自動的に値をリセットできます
final recipeNameProvider = StateProvider.autoDispose((ref) {
  return '';
});

// 料理メモの受け渡しを行うためのProvider
// ※ autoDisposeを付けることで自動的に値をリセットできます
final recipeMemoProvider = StateProvider.autoDispose((ref) {
  return '';
});

// 料理材料名の受け渡しを行うためのProvider
// ※ autoDisposeを付けることで自動的に値をリセットできます
final ingredientNameProvider = StateProvider.autoDispose((ref) {
  return '';
});

// 料理材料数量の受け渡しを行うためのProvider
// ※ autoDisposeを付けることで自動的に値をリセットできます
final ingredientNumProvider = StateProvider.autoDispose((ref) {
  return '';
});

// 材料controller
final ingredientNameControllerStateProvider = StateProvider.autoDispose((ref) {
  return TextEditingController(text: '');
});

final ingredientNumControllerStateProvider = StateProvider.autoDispose((ref) {
  return TextEditingController(text: '');
});

final procedureListNotifierProvider =
    StateNotifierProvider<ProcedureListNotifier, List<Procedure>>(
  (ref) => ProcedureListNotifier(),
);
