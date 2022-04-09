import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:recipe/domain/type_adapter/ingredient_unit/ingredient_unit.dart';
import 'package:recipe/view/other/ingredient_unit_edit/ingredient_unit_edit_model.dart';

class IngredientUnitEditPage extends ConsumerWidget {
  const IngredientUnitEditPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '材料の単位を編集',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor),
        ),
      ),
      body: ValueListenableBuilder(
          valueListenable: IngredientUnitBoxes.getIngredientUnit().listenable(),
          builder: (context, Box box, widget) {
            IngredientUnitEditModel ingredientUnitEditModel =
                IngredientUnitEditModel();
            final ingredientUnitList =
                ingredientUnitEditModel.fetchIngredientUnitList();
            String? addedUnit;
            String? errorTextWhenAdding;

            return ListView(
              children: [
                GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('単位を追加'),
                              content: TextField(
                                onChanged: (value) {
                                  addedUnit = value;
                                },
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('キャンセル'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                TextButton(
                                  child: Text('OK'),
                                  onPressed: () {
                                    errorTextWhenAdding =
                                        ingredientUnitEditModel
                                            .outputAddError(addedUnit);
                                    if (errorTextWhenAdding == null) {
                                      ingredientUnitEditModel
                                          .addIngredientUnit(addedUnit!);
                                      Navigator.of(context).pop();
                                      final snackBar = SnackBar(
                                          content: Text(
                                        '$addedUnitを追加しました',
                                        textAlign: TextAlign.center,
                                      ));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    } else {
                                      final snackBar = SnackBar(
                                          content: Text(
                                        '$errorTextWhenAdding',
                                        textAlign: TextAlign.center,
                                      ));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                  },
                                ),
                              ],
                            );
                          });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: Colors.black))),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 16,
                          ),
                          Text(
                            '単位を追加',
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ],
                      ),
                    )),
                ReorderableListView.builder(
                  onReorder: (oldIndex, newIndex) {
                    ingredientUnitEditModel.reorderIngredientUnitList(
                        oldIndex, newIndex);
                  },
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: ingredientUnitList.length,
                  itemBuilder: (context, index) {
                    return Slidable(
                      key: ValueKey(ingredientUnitList[index]),
                      actionPane: SlidableDrawerActionPane(),
                      secondaryActions: [
                        IconSlideAction(
                          color: Colors.red,
                          iconWidget: Text('delete'),
                          onTap: () {
                            ingredientUnitEditModel.deleteIngredientUnit(
                                ingredientUnitList[index]);
                          },
                        ),
                      ],
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.black))),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Text(
                                    '${ingredientUnitList[index]}',
                                    style:
                                        Theme.of(context).textTheme.headline4,
                                  ),
                                  Spacer(),
                                  Icon(Icons.drag_handle),
                                  SizedBox(
                                    width: 16,
                                  ),
                                ],
                              )
                            ],
                          )),
                    );
                  },
                ),
                ElevatedButton(
                    onPressed: () {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text('確認'),
                          content: Text('本当に単位を初期に戻しますか？'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                // Navigator.pop(context, 'Cancel'),
                                Navigator.of(context).pop();
                              },
                              child: Text('いいえ'),
                            ),
                            TextButton(
                              onPressed: () async {
                                await ingredientUnitEditModel
                                    .deleteIngredientUnitList();

                                Navigator.of(context).pop();
                                final snackBar = SnackBar(
                                    content: Text(
                                  '単位を初期に戻しました',
                                  textAlign: TextAlign.center,
                                ));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              },
                              child: Text('はい'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Text('単位を初期に戻す')),
              ],
            );
          }),
    );
  }
}
