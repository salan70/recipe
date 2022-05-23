import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:recipe/domain/recipe.dart';
import 'package:recipe/state/ingredient_list/ingredient_list_state.dart';

final ingredientListNotifierProvider =
    StateNotifierProvider.autoDispose<IngredientListNotifier, List<Ingredient>>(
  (ref) => IngredientListNotifier(),
);
