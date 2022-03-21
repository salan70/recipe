// outside
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

// inside
import 'package:recipe/domain/recipe.dart';
import 'package:recipe/components/providers.dart';

class ProcedureListNotifier extends StateNotifier<List<Procedure>> {
  ProcedureListNotifier() : super([Procedure(id: Uuid().v4(), content: '')]);

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

  List<Procedure> getList(List<Procedure> procedureList) {
    return state = procedureList;
  }
}

class ProceduresListWidget extends ConsumerWidget {
  const ProceduresListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final procedureList = ref.watch(procedureListNotifierProvider);
    final procedureListNotifier =
        ref.watch(procedureListNotifierProvider.notifier);

    final contentIsChanged = ref.watch(contentIsChangedProvider);
    final contentIsChangedNotifier =
        ref.watch(contentIsChangedProvider.notifier);

    return Column(
      children: [
        Builder(builder: (context) {
          return ReorderableListView(
            onReorder: (oldIndex, newIndex) =>
                procedureListNotifier.reorder(oldIndex, newIndex),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              for (int index = 0; index < procedureList.length; index++)
                Slidable(
                  key: ValueKey(procedureList[index].id),
                  actionPane: SlidableDrawerActionPane(),
                  secondaryActions: [
                    IconSlideAction(
                      color: Colors.red,
                      iconWidget: Text('delete'),
                      onTap: () => procedureListNotifier
                          .remove(procedureList[index].id!),
                    ),
                  ],
                  child: Row(
                    children: [
                      Expanded(flex: 1, child: Text((index + 1).toString())),
                      Expanded(
                          flex: 15,
                          child: TextField(
                            controller: contentIsChanged == false
                                ? TextEditingController(
                                    text: procedureList[index].content)
                                : null,
                            maxLines: null,
                            onChanged: (String value) {
                              procedureList[index] = Procedure(
                                  id: procedureList[index].id, content: value);
                              contentIsChangedNotifier.update((state) => true);
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
            final Procedure procedures = Procedure(id: id, content: '');
            procedureListNotifier.add(procedures);
          },
          child: Text('追加'),
        )
      ],
    );
  }
}
