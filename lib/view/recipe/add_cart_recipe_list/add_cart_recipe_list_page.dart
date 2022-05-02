import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:recipe/components/widgets/recipe_card_widget/recipe_card_widget.dart';
import 'package:recipe/state/auth/auth_provider.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:badges/badges.dart';

import 'package:recipe/components/providers.dart';

import '../add_cart_recipe_detail/add_cart_recipe_detail_page.dart';
import 'add_cart_recipe_list_model.dart';

// レシピ一覧画面
class AddCartRecipeListPage extends ConsumerWidget {
  AddCartRecipeListPage({Key? key}) : super(key: key);

  final ScrollController listViewController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userStateNotifierProvider);

    final recipes = ref.watch(recipeListStreamProvider);
    final recipeListInCartStream = ref.watch(recipeListInCartStreamProvider);

    final recipeForInCartListState =
        ref.watch(recipeForInCartListNotifierProvider);
    final recipeForInCartListStateNotifier =
        ref.watch(recipeForInCartListNotifierProvider.notifier);

    final stateIsChanged = ref.watch(stateIsChangedProvider);
    final stateIsChangedNotifier = ref.watch(stateIsChangedProvider.notifier);

    AddCartRecipeListModel addCartRecipeListModel =
        AddCartRecipeListModel(user: user!);

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(
          'かごに追加するレシピを選択',
        ),
      ),
      body: SnappingSheet(
        child: recipes.when(
            error: (error, stack) => Text('Error: $error'),
            loading: () => const CircularProgressIndicator(),
            data: (recipes) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];

                      return GestureDetector(
                        ///画面遷移
                        onTap: () {
                          stateIsChangedNotifier.state = false;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                fullscreenDialog: false,
                                builder: (context) => AddBasketRecipeDetailPage(
                                    recipe.recipeId!,
                                    'add_cart_recipe_list_page'),
                              ));
                        },

                        child: RecipeCardWidget(recipe),
                      );
                    }),
              );
            }),

        ///snapingsheet
        lockOverflowDrag: true,
        snappingPositions: [
          SnappingPosition.factor(
            positionFactor: 0.0,
            snappingCurve: Curves.easeOutExpo,
            snappingDuration: Duration(seconds: 1),
            grabbingContentOffset: GrabbingContentOffset.top,
          ),
          SnappingPosition.factor(
            snappingCurve: Curves.elasticOut,
            snappingDuration: Duration(milliseconds: 1000),
            positionFactor: 0.7,
          ),
        ],
        grabbingHeight: 24,
        sheetAbove: null,
        grabbing: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(blurRadius: 25, color: Colors.black.withOpacity(0.2)),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(top: 9),
                width: 100,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              Container(
                color: Colors.grey[200],
                height: 2,
                margin: EdgeInsets.all(15).copyWith(top: 0, bottom: 0),
              )
            ],
          ),
        ),
        sheetBelow: SnappingSheetContent(
          draggable: true,
          childScrollController: listViewController,
          child: recipeListInCartStream.when(
              error: (error, stack) {
                print('「recipeListInCartStream.when」でエラー： $error');
                return Text('Error: $error');
              },
              loading: () => const CircularProgressIndicator(),
              data: (recipesForInCartList) {
                if (stateIsChanged == false) {
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    recipeForInCartListStateNotifier
                        .getList(recipesForInCartList);
                  });
                }

                return Container(
                  color: Colors.white,
                  child: ListView.builder(
                      controller: listViewController,
                      itemCount: recipeForInCartListState.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                recipeForInCartListState[index]
                                    .recipeName
                                    .toString(),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                child: Text(
                                    '合計${recipeForInCartListState[index].forHowManyPeople! * recipeForInCartListState[index].countInCart!}人分'),
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        stateIsChangedNotifier.state = true;
                                        if (recipeForInCartListState[index]
                                                .countInCart! >
                                            0) {
                                          recipeForInCartListStateNotifier
                                              .decrease(
                                                  recipeForInCartListState[
                                                          index]
                                                      .recipeId!);
                                        }
                                      },
                                      icon: recipeForInCartListState[index]
                                                  .countInCart! ==
                                              0
                                          ? Icon(Icons.remove_circle_outline)
                                          : Icon(Icons.remove_circle)),
                                  Text(
                                      '× ${recipeForInCartListState[index].countInCart!}'),
                                  IconButton(
                                      onPressed: () {
                                        stateIsChangedNotifier.state = true;
                                        recipeForInCartListStateNotifier
                                            .increase(
                                                recipeForInCartListState[index]
                                                    .recipeId!);
                                      },
                                      icon: Icon(Icons.add_circle)),
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                );
              }),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 64.0,
          child: Row(
            children: [
              Expanded(
                  child: SizedBox(
                height: 64,
                child: Container(
                    child: Badge(
                  toAnimate: false,
                  badgeContent: Text(
                    '${recipeForInCartListStateNotifier.calculateCountSum()}',
                    style: TextStyle(color: Colors.white),
                  ),
                  child: Icon(Icons.shopping_cart_outlined),
                  position: BadgePosition.topEnd(top: 10, end: 50),
                )),
              )),
              Expanded(child: Container()),
              Expanded(
                  child: Container(
                child: ElevatedButton(
                  onPressed: () async {
                    if (recipeForInCartListState.isEmpty != true) {
                      bool zeroIsInclude = addCartRecipeListModel
                          .checkCart(recipeForInCartListState);

                      if (zeroIsInclude) {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text('確認'),
                            content: Text('数量が0のレシピがありますがよろしいですか？'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel'),
                                child: Text('いいえ'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  print('はい');

                                  if (await addCartRecipeListModel
                                      .updateCountsInCart(
                                          recipeForInCartListState)) {
                                    int popInt = 0;
                                    Navigator.popUntil(
                                        context, (_) => popInt++ >= 2);
                                    final snackBar = SnackBar(
                                        content: const Text(
                                      'カートを更新しました',
                                      textAlign: TextAlign.center,
                                    ));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  } else {
                                    final snackBar = SnackBar(
                                        content: const Text(
                                      'カートの更新に失敗しました',
                                      textAlign: TextAlign.center,
                                    ));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                },
                                child: Text('はい'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        if (await addCartRecipeListModel
                            .updateCountsInCart(recipeForInCartListState)) {
                          Navigator.pop(context);
                          final snackBar = SnackBar(
                              content: const Text(
                            'カートを更新しました',
                            textAlign: TextAlign.center,
                          ));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          final snackBar = SnackBar(
                              content: const Text(
                            'カートの更新に失敗しました',
                            textAlign: TextAlign.center,
                          ));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      }
                    }
                  },
                  child: Text('確定'),
                ),
              ))
            ],
          ),
        ),
        shape: CircularNotchedRectangle(),
      ),
    );
  }
}
