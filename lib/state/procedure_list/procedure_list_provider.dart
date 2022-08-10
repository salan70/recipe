import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/recipe.dart';
import 'procedure_list_state.dart';

final procedureListNotifierProvider =
    StateNotifierProvider.autoDispose<ProcedureListNotifier, List<Procedure>>(
  (ref) => ProcedureListNotifier(),
);
