import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipe/components/widgets/recipe_card_widget/recipe_card_widget.dart';
import 'package:recipe/state/auth/auth_provider.dart';
import 'package:recipe/state/other_provider/providers.dart';
import 'package:recipe/view/recipe/add_cart_recipe_detail/add_cart_recipe_detail_page.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'add_cart_recipe_list_model.dart';

// レシピ一覧画面
class AddCartRecipeListPage extends ConsumerWidget {
  AddCartRecipeListPage({Key? key}) : super(key: key);

  final PanelController pageController = PanelController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userStateNotifierProvider);

    final recipes = ref.watch(recipeListStreamProvider);

    final recipeForInCartListState =
        ref.watch(recipeForInCartListNotifierProvider);
    final recipeForInCartListStateNotifier =
        ref.watch(recipeForInCartListNotifierProvider.notifier);

    final recipeListInCartPanelIsOpen =
        ref.watch(recipeListInCartPanelIsOpenProvider);
    final recipeListInCartPanelIsOpenNotifier =
        ref.watch(recipeListInCartPanelIsOpenProvider.notifier);

    final stateIsChangedNotifier = ref.watch(stateIsChangedProvider.notifier);

    final addCartRecipeListModel = AddCartRecipeListModel(user: user!);

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text(
          'カートに追加するレシピを選択',
        ),
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          SlidingUpPanel(
            controller: pageController,
            maxHeight: MediaQuery.of(context).size.height * 0.6.h,
            minHeight: 20.h,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
            ).r,
            body: ListView(
              children: [
                recipes.when(
                  error: (error, stack) => Text('Error: $error'),
                  loading: () => const CircularProgressIndicator(),
                  data: (recipes) {
                    return Padding(
                      padding: const EdgeInsets.all(8).r,
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemCount: recipes.length,
                        itemBuilder: (context, index) {
                          final recipe = recipes[index];

                          return GestureDetector(
                            ///画面遷移
                            onTap: () {
                              stateIsChangedNotifier.state = false;
                              Navigator.push<MaterialPageRoute<dynamic>>(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AddBasketRecipeDetailPage(
                                    recipeId: recipe.recipeId!,
                                    fromPageName: 'add_cart_recipe_list_page',
                                  ),
                                ),
                              );
                            },

                            child: RecipeCardWidget(recipe: recipe),
                          );
                        },
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 240.h,
                )
              ],
            ),
            panelBuilder: (sc) =>
                _recipeListInCartPanel(sc, pageController, context, ref),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(
          margin: const EdgeInsets.only(left: 64, right: 24).r,
          height: 64.0.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 64.h,
                child: Badge(
                  position: BadgePosition.topEnd(top: 5, end: -5),
                  padding: const EdgeInsets.all(6).r,
                  badgeContent: SizedBox(
                    child: recipeForInCartListStateNotifier
                                .calculateCountSum() >=
                            99
                        ? const Text(
                            '99+',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          )
                        : recipeForInCartListStateNotifier
                                    .calculateCountSum() >=
                                10
                            ? Text(
                                '${recipeForInCartListStateNotifier.calculateCountSum()}',
                                style: const TextStyle(color: Colors.white),
                              )
                            : Text(
                                ' ${recipeForInCartListStateNotifier.calculateCountSum()} ',
                                style: const TextStyle(color: Colors.white),
                              ),
                  ),
                  child: IconButton(
                    onPressed: () {
                      if (recipeListInCartPanelIsOpen) {
                        pageController.close();
                      } else {
                        pageController.open();
                      }
                      recipeListInCartPanelIsOpenNotifier.state =
                          !recipeListInCartPanelIsOpen;
                    },
                    icon: Icon(
                      Icons.shopping_cart_rounded,
                      size: 32.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 144.w,
                child: ElevatedButton(
                  onPressed: () async {
                    if (recipeForInCartListState.isEmpty != true) {
                      if (addCartRecipeListModel
                          .zeroIsIncludeInCart(recipeForInCartListState)) {
                        await showDialog<AlertDialog>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('確認'),
                            content: const Text('数量が0のレシピがありますがよろしいですか？'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel'),
                                child: const Text('いいえ'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await EasyLoading.show(status: 'loading...');
                                  final errorText = await addCartRecipeListModel
                                      .updateCountsInCart(
                                    recipeForInCartListState,
                                  );
                                  if (errorText == null) {
                                    var popInt = 0;
                                    Navigator.popUntil(
                                      context,
                                      (_) => popInt++ >= 2,
                                    );
                                    await EasyLoading.showSuccess('カートを更新しました');
                                  } else {
                                    await EasyLoading.dismiss();
                                    await showDialog<AlertDialog>(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('カート更新失敗'),
                                          content: Text(errorText),
                                          actions: [
                                            TextButton(
                                              child: const Text('閉じる'),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                                child: const Text('はい'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        await EasyLoading.show(status: 'loading...');
                        final errorText = await addCartRecipeListModel
                            .updateCountsInCart(recipeForInCartListState);
                        if (errorText == null) {
                          Navigator.pop(context);
                          await EasyLoading.showSuccess('カートを更新しました');
                        } else {
                          await EasyLoading.dismiss();
                          await showDialog<AlertDialog>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('カート更新失敗'),
                                content: Text(errorText),
                                actions: [
                                  TextButton(
                                    child: const Text('閉じる'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
                    }
                  },
                  child: Text(
                    '確定',
                    style: TextStyle(fontSize: 20.sp),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _recipeListInCartPanel(
    ScrollController sc,
    PanelController pc,
    BuildContext context,
    WidgetRef ref,
  ) {
    final user = ref.watch(userStateNotifierProvider);
    final recipeListInCartStream = ref.watch(recipeListInCartStreamProvider);

    final recipeForInCartListState =
        ref.watch(recipeForInCartListNotifierProvider);
    final recipeForInCartListStateNotifier =
        ref.watch(recipeForInCartListNotifierProvider.notifier);

    final stateIsChanged = ref.watch(stateIsChangedProvider);
    final stateIsChangedNotifier = ref.watch(stateIsChangedProvider.notifier);

    final addCartRecipeListModel = AddCartRecipeListModel(user: user!);

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Container(
        padding: const EdgeInsets.only(right: 16, left: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).bottomAppBarColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
          ),
        ),
        child: Column(
          children: [
            /// title
            SizedBox(
              height: 8.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 30,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'カートに入っているレシピ',
                  style: Theme.of(context).primaryTextTheme.headline6,
                ),
                TextButton.icon(
                  icon: Icon(
                    Icons.delete_rounded,
                    color: Theme.of(context).errorColor,
                  ),
                  label: Text(
                    '空にする',
                    style: TextStyle(color: Theme.of(context).errorColor),
                  ),
                  onPressed: () {
                    showDialog<AlertDialog>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('確認'),
                        content: const Text('本当にカートを空にしてよろしいですか？'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('いいえ'),
                          ),
                          TextButton(
                            onPressed: () async {
                              await EasyLoading.show(status: 'loading...');
                              final errorText = await addCartRecipeListModel
                                  .deleteAllRecipeFromCart(
                                recipeForInCartListState,
                              );
                              if (errorText == null) {
                                Navigator.pop(context);
                                await EasyLoading.showSuccess('カートを空にしました');
                              } else {
                                await EasyLoading.dismiss();
                                await showDialog<AlertDialog>(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('カート更新失敗'),
                                      content: Text(errorText),
                                      actions: [
                                        TextButton(
                                          child: const Text('閉じる'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            child: const Text('はい'),
                          ),
                        ],
                      ),
                    );
                  },
                )
              ],
            ),
            SizedBox(
              height: 8.h,
            ),
            const Divider(),
            // body
            recipeListInCartStream.when(
              error: (error, stack) {
                return Text('Error: $error');
              },
              loading: () => const CircularProgressIndicator(),
              data: (recipesForInCartList) {
                if (stateIsChanged == false) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    recipeForInCartListStateNotifier
                        .getList(recipesForInCartList);
                  });
                }

                return Flexible(
                  child: ListView.builder(
                    controller: sc,
                    itemCount: recipeForInCartListState.length,
                    itemBuilder: (context, index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 160.w,
                            child: Text(
                              recipeForInCartListState[index]
                                  .recipeName
                                  .toString(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  Theme.of(context).primaryTextTheme.subtitle1,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                '計${recipeForInCartListState[index].forHowManyPeople! * recipeForInCartListState[index].countInCart!}人分',
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .subtitle2,
                              ),
                              IconButton(
                                onPressed: () {
                                  stateIsChangedNotifier.state = true;
                                  if (recipeForInCartListState[index]
                                          .countInCart! >
                                      0) {
                                    recipeForInCartListStateNotifier.decrease(
                                      recipeForInCartListState[index].recipeId!,
                                    );
                                  }
                                },
                                icon: recipeForInCartListState[index]
                                            .countInCart! ==
                                        0
                                    ? const Icon(
                                        Icons.remove_circle_outline,
                                      )
                                    : const Icon(Icons.remove_circle),
                              ),
                              Text(
                                '× ${recipeForInCartListState[index].countInCart!}',
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .subtitle2,
                              ),
                              IconButton(
                                onPressed: () {
                                  stateIsChangedNotifier.state = true;
                                  if (recipeForInCartListState[index]
                                          .countInCart! <
                                      99) {
                                    recipeForInCartListStateNotifier.increase(
                                      recipeForInCartListState[index].recipeId!,
                                    );
                                  }
                                },
                                icon: recipeForInCartListState[index]
                                            .countInCart! ==
                                        99
                                    ? const Icon(Icons.add_circle_outline)
                                    : const Icon(Icons.add_circle),
                              )
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
