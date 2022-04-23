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
                Center(
                  child: TextButton(
                    child: Text(
                      '単位を追加',
                    ),
                    onPressed: () {
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
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 16, right: 16),
                  child: Text(
                    '現在の単位一覧',
                    style: Theme.of(context).primaryTextTheme.headline6,
                  ),
                ),
                ReorderableListView.builder(
                  itemExtent: 40,
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
                          margin: EdgeInsets.only(left: 16),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                            color: Theme.of(context).dividerColor,
                          ))),
                          child: ListTile(
                            title: Text(
                              '${ingredientUnitList[index]}',
                              style:
                                  Theme.of(context).primaryTextTheme.subtitle1,
                            ),
                            trailing: Icon(Icons.drag_handle),
                          )),
                    );
                  },
                ),
                Center(
                  child: TextButton(
                    child: Text(
                      '単位を初期に戻す',
                      style: TextStyle(color: Theme.of(context).errorColor),
                    ),
                    onPressed: () {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text('確認'),
                          content: Text('本当に単位を初期に戻しますか？'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
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
                              child: Text('はい',
                                  style: TextStyle(
                                      color: Theme.of(context).errorColor)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }),
    );
  }
}
