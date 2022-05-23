import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:recipe/domain/recipe.dart';
import 'package:recipe/state/procedure_list/procedure_list_state.dart';

final procedureListNotifierProvider =
    StateNotifierProvider.autoDispose<ProcedureListNotifier, List<Procedure>>(
  (ref) => ProcedureListNotifier(),
);
