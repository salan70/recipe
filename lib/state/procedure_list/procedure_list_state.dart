import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../domain/recipe.dart';

class ProcedureListNotifier extends StateNotifier<List<Procedure>> {
  ProcedureListNotifier()
      : super([Procedure(id: const Uuid().v4(), content: '')]);

  bool add(Procedure procedure) {
    if (state.length < 30) {
      state = [...state, procedure];
      return true;
    } else {
      return false;
    }
  }

  void remove(String id) {
    state = [
      for (final procedure in state)
        if (procedure.id != id) procedure,
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

  List<Procedure> getList(List<Procedure> procedureList) {
    return state = procedureList;
  }
}
