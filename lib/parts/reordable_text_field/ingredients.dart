import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:recipe/domain/recipe.dart';
import 'package:recipe/providers.dart';
import 'package:uuid/uuid.dart';

class TextFieldStateIngredients {
  final String id;
  final TextEditingController controller;

  TextFieldStateIngredients(this.id, this.controller);
}

class ReorderableMultiTextFieldControllerIngredients
    extends ValueNotifier<List<TextFieldStateIngredients>> {
  ReorderableMultiTextFieldControllerIngredients(
      List<TextFieldStateIngredients> value)
      : super(value);

  void add(text) {
    final state = TextFieldStateIngredients(
      Uuid().v4(),
      TextEditingController(text: text),
    );

    value = [...value, state];
    print('-----------');
    value.asMap().forEach((int i, value) {
      print(i);
      print(value.toString());
    });
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

class ReorderableMultiTextFieldIngredients extends ConsumerWidget {
  final ReorderableMultiTextFieldControllerIngredients controller;
  const ReorderableMultiTextFieldIngredients({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Ingredient ingredient = Ingredient();

    int ingredientIndex;
    String? ingredientName;
    String? ingredientNum;

    // final ingredientName = ref.watch(ingredientNameProvider);
    // final ingredientNum = ref.watch(ingredientNumProvider);

    return ValueListenableBuilder<List<TextFieldStateIngredients>>(
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
                          // controller: textFieldState.controller,
                          decoration: InputDecoration.collapsed(
                              hintText: "fill out here"),
                          onChanged: (String value) {
                            print('');
                            ingredient.ingredientName = value;
                            print(ingredient.ingredientName);
                          },
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          // controller: textFieldState.controller,
                          decoration: InputDecoration.collapsed(
                              hintText: "fill out here"),
                          onChanged: (String value) {
                            ingredient.ingredientNum = value;
                            print(ingredient.ingredientNum);
                          },
                        ),
                      ),
                      // Expanded(
                      //   child: DropdownButton<String>(
                      //     value: _selectedKey,
                      //     icon: const Icon(Icons.arrow_downward),
                      //     iconSize: 24,
                      //     elevation: 16,
                      //     style: const TextStyle(color: Colors.deepPurple),
                      //     underline: Container(
                      //       height: 2,
                      //       color: Colors.deepPurpleAccent,
                      //     ),
                      //     onChanged: () =>
                      //         context.read(ingredientsDropBoxProvider).state++,
                      //     items: <String>['One', 'Two', 'Free', 'Four']
                      //         .map<DropdownMenuItem<String>>((String value) {
                      //       return DropdownMenuItem<String>(
                      //         value: value,
                      //         child: Text(value),
                      //       );
                      //     }).toList(),
                      //   ),
                      // ),
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
