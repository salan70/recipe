import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../domain/recipe.dart';

class IngredientListNotifier extends StateNotifier<List<Ingredient>> {
  IngredientListNotifier()
      : super([
          Ingredient(
            id: const Uuid().v4(),
            symbol: null,
            name: '',
            amount: '',
            unit: null,
          ),
        ]);

  bool add(Ingredient ingredient) {
    if (state.length < 30) {
      state = [...state, ingredient];
      return true;
    } else {
      return false;
    }
  }

  void remove(String id) {
    state = [
      for (final ingredient in state)
        if (ingredient.id != id) ingredient,
    ];
  }

  void reorder(int oldIndex, int newIndex) {
    var useNewIndex = newIndex;
    if (oldIndex < useNewIndex) {
      useNewIndex -= 1;
    }
    final item = state.removeAt(oldIndex);
    state = [...state..insert(useNewIndex, item)];
  }

  void editSymbol(String id, String symbol) {
    state = [
      for (final ingredient in state)
        if (ingredient.id == id)
          if (ingredient.symbol == symbol)
            ingredient.copyWith(symbol: '')
          else
            ingredient.copyWith(symbol: symbol)
        else
          ingredient,
    ];
  }

  void editName(String id, String name) {
    state = [
      for (final ingredient in state)
        if (ingredient.id == id)
          ingredient.copyWith(name: name)
        else
          ingredient,
    ];
  }

  void editAmount(String id, String amount) {
    state = [
      for (final ingredient in state)
        if (ingredient.id == id)
          ingredient.copyWith(amount: amount)
        else
          ingredient,
    ];
  }

  void editUnit(String id, String unit) {
    state = [
      for (final ingredient in state)
        if (ingredient.id == id)
          ingredient.copyWith(unit: unit)
        else
          ingredient,
    ];
  }

  List<Ingredient> getList(List<Ingredient> ingredientList) {
    return state = ingredientList;
  }
}
