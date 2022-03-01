// outside
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

// inside
import 'package:recipe/domain/recipe.dart';
import 'package:recipe/providers.dart';

class ProcedureListNotifier extends StateNotifier<List<Procedure>> {
  // ProceduresListNotifier(List<Procedures> state) : super(state);
  ProcedureListNotifier() : super([Procedure(id: Uuid().v4(), content: "")]);

  void add(Procedure procedure) {
    state = [...state, procedure];
  }

  void remove(String id) {
    state = [
      for (final procedure in state)
        if (procedure.id != id) procedure,
    ];
  }

  void reorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = state.removeAt(oldIndex);
    state = [...state..insert(newIndex, item)];
  }
}

class ProceduresListWidget extends ConsumerWidget {
  const ProceduresListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final proceduresList = ref.watch(procedureListNotifierProvider);
    final notifier = ref.watch(procedureListNotifierProvider.notifier);

    return Column(
      children: [
        Builder(builder: (context) {
          return ReorderableListView(
            onReorder: (oldIndex, newIndex) =>
                notifier.reorder(oldIndex, newIndex),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              for (int index = 0; index < proceduresList.length; index++)
                Slidable(
                  key: ValueKey(proceduresList[index].id),
                  actionPane: SlidableDrawerActionPane(),
                  secondaryActions: [
                    IconSlideAction(
                      color: Colors.red,
                      iconWidget: Text("delete"),
                      onTap: () => notifier.remove(proceduresList[index].id!),
                    ),
                  ],
                  child: Row(
                    children: [
                      Expanded(flex: 1, child: Text((index + 1).toString())),
                      Expanded(
                          flex: 15,
                          child: TextField(
                            maxLines: null,
                            onChanged: (String value) {
                              proceduresList[index] = Procedure(
                                  id: proceduresList[index].id, content: value);

                              ///テスト用
                              // for (int i = 0; i < proceduresList.length; i++) {
                              //   print(proceduresList[i].id.toString() +
                              //       ":" +
                              //       proceduresList[i].content);
                              // }
                              // print("------------------");
                            },
                          )),
                      Icon(Icons.drag_handle),
                    ],
                  ),
                ),
            ],
          );
        }),
        TextButton(
          onPressed: () {
            String id = Uuid().v4();
            final Procedure procedures = Procedure(id: id, content: "");
            notifier.add(procedures);
            print(id);
          },
          child: Text("追加"),
        )
      ],
    );
  }
}
