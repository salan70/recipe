import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:recipe/domain/recipe.dart';
import 'package:recipe/providers.dart';
import 'package:uuid/uuid.dart';

class TextFieldStateProcedures {
  final String id;
  final TextEditingController controller;

  TextFieldStateProcedures(this.id, this.controller);
}

class ReorderableMultiTextFieldController
    extends ValueNotifier<List<TextFieldStateProcedures>> {
  ReorderableMultiTextFieldController(List<TextFieldStateProcedures> value)
      : super(value);

  void add(text) {
    final state = TextFieldStateProcedures(
      Uuid().v4(),
      TextEditingController(text: text),
    );

    value = [...value, state];
  }

  void remove(String id) {
    final removedText = value.where((element) => element.id == id);
    if (removedText.isEmpty) {
      throw "Textがありません";
    }

    value = value.where((element) => element.id != id).toList();

    Future.delayed(Duration(seconds: 1)).then(
      (value) => removedText.first.controller.dispose(),
    );
  }

  void reorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = value.removeAt(oldIndex);
    value = [...value..insert(newIndex, item)];
  }

  @override
  void dispose() {
    value.forEach((element) {
      element.controller.dispose();
    });
    super.dispose();
  }
}

class ReorderableMultiTextFieldProcedures extends StatelessWidget {
  final ReorderableMultiTextFieldController controller;
  const ReorderableMultiTextFieldProcedures({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<TextFieldStateProcedures>>(
      valueListenable: controller,
      builder: (context, state, _) {
        return ReorderableListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: state
              .map(
                (textFieldState) => Slidable(
                  key: ValueKey(textFieldState.id),
                  actionPane: SlidableDrawerActionPane(),
                  secondaryActions: [
                    IconSlideAction(
                      color: Colors.red,
                      iconWidget: Text("delete"),
                      onTap: () => controller.remove(textFieldState.id),
                    ),
                  ],
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          maxLines: null,
                          controller: textFieldState.controller,
                          decoration: InputDecoration.collapsed(
                              hintText: "fill out here"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 8.0,
                          top: 8.0,
                          left: 16,
                        ),
                        child: Icon(Icons.drag_handle),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
          onReorder: (oldIndex, newIndex) => controller.reorder(
            oldIndex,
            newIndex,
          ),
        );
      },
    );
  }
}

//

class ProcedureListNotifier extends StateNotifier<List<Procedure>> {
  ProcedureListNotifier([List<Procedure>? initialProcedure])
      : super(initialProcedure ?? []);

  ///Procedure関連
  // 新しいProcedureを追加するメソッド
  void addProcedure(Procedure procedure) {
    state = [...state, procedure];
  }

  // IDを指定して、Procedureを削除するメソッド
  void removeProcedure(String procedureId) {
    state = [
      for (final procedure in state)
        if (procedure.id != procedureId) procedure,
    ];
  }
}

class ProceduresTextFieldState {
  final String id;
  // final TextEditingController controller;

  ProceduresTextFieldState(this.id);
}

class TodoViewModelProvider extends StateNotifier<ProcedureState> {
  TodoViewModelProvider(this._reader, this._todoRepository)
      : super(const ProcedureState()) {
    getProcedures();
  }

  final Reader _reader;
  final TodoRepository _todoRepository;

  Future<void> addTodo(String title) async {
    final todo = await _todoRepository.addTodo(Todo(
      title: title,
      isDone: 0,
    ));

    state = state.copyWith(
      todos: [todo, ...state.todos],
    );
  }

  Future<void> getTodos() async {
    final todos = await _todoRepository.getTodos();

    state = state.copyWith(
      todos: todos,
    );
  }
}

Widget procedureList(WidgetRef ref) {
  final procedureViewModel = ref.watch(procedureListNotifierProvider.notifier);
  final procedureState = ref.watch(procedureListNotifierProvider);

  return ListView.builder(
    itemCount: procedureState.todos.length,
    itemBuilder: (BuildContext context, int index) {
      final todo = procedureState.todos[index];

      return procedureItem(todo, index, procedureViewModel);
    },
  );
}
