import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe/domain/recipe.dart';

class ProceduresListNotifier extends StateNotifier<List<Procedures>> {
  ProceduresListNotifier() : super([Procedures(1, "aaa")]);

  void addTextField(Procedures procedures) {
    state = [...state, procedures];
  }

  void editText(int id, Procedures procedures) {
    state = [
      for (final procedures in state)
        if (procedures.id == id) procedures,
    ];
    print("a");
  }
}

final proceduresTextFieldListNotifierProvider =
    StateNotifierProvider<ProceduresListNotifier, List<Procedures>>(
  (ref) => ProceduresListNotifier(),
);

class ProceduresListWidget extends ConsumerWidget {
  const ProceduresListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final proceduresList = ref.watch(proceduresTextFieldListNotifierProvider);
    final notifier =
        ref.watch(proceduresTextFieldListNotifierProvider.notifier);

    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: proceduresList.length,
          itemBuilder: (BuildContext context, int index) {
            final id = index + 1;
            return Row(
              children: [
                Expanded(child: Text(id.toString())),
                Expanded(child: TextField(
                  onChanged: (String value) {
                    proceduresList[index] = Procedures(id, value);

                    for (int i = 0; i < proceduresList.length; i++) {
                      print(proceduresList[i].id.toString() +
                          ":" +
                          proceduresList[i].content);
                    }
                    print("------------------");
                  },
                )),
              ],
            );
          },
        ),
        TextButton(
          onPressed: () {
            int id = proceduresList.length + 1;
            final Procedures procedures = Procedures(id, "");
            notifier.addTextField(procedures);
          },
          child: Text("追加"),
        )
      ],
    );
  }
}
