import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:recipe/state/other_provider/providers.dart';
import 'package:recipe/domain/cart.dart';
import 'package:recipe/domain/type_adapter/cart_item/cart_item.dart';
import 'package:recipe/view/cart/cart_list_recipe_detail/cart_list_recipe_detail_page.dart';
import 'cart_list_model.dart';

class CartListPage extends ConsumerWidget {
  const CartListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CartListModel cartListModel = CartListModel();

    final recipeListInCartStream = ref.watch(recipeListInCartStreamProvider);
    final notBuyIngredientListIsOpen =
        ref.watch(notBuyIngredientListIsOpenProvider);
    final notBuyIngredientListIsOpenNotifier =
        ref.watch(notBuyIngredientListIsOpenProvider.notifier);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'カート',
          ),
          bottom: TabBar(
            indicatorColor: Theme.of(context).primaryColorDark,
            tabs: <Widget>[
              Tab(
                  child: Text(
                '材料',
                style: Theme.of(context).primaryTextTheme.subtitle1,
              )),
              Tab(
                  child: Text(
                'レシピ',
                style: Theme.of(context).primaryTextTheme.subtitle1,
              )),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            /// 材料タブ
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 8, right: 8).r,
              child: ValueListenableBuilder(
                  valueListenable: CartItemBoxes.getCartItems().listenable(),
                  builder: (context, box, widget) {
                    return recipeListInCartStream.when(
                        error: (error, stack) => Text('Error: $error'),
                        loading: () => const CircularProgressIndicator(),
                        data: (recipeListInCart) {
                          List<IngredientPerInCartRecipe>
                              ingredientPerInCartRecipeList = [];

                          for (var recipe in recipeListInCart) {
                            List<IngredientPerInCartRecipe> addList =
                                cartListModel
                                    .createIngredientPerInCartRecipeList(
                                        recipe);
                            for (var item in addList)
                              ingredientPerInCartRecipeList.add(item);
                          }

                          List<IngredientInCartPerRecipeList>
                              ingredientListInCartPerRecipeList = cartListModel
                                  .createIngredientListInCartPerRecipeList(
                                      ingredientPerInCartRecipeList);

                          List<IngredientInCartPerRecipeList> buyList =
                              cartListModel.createBuyList(
                                  ingredientListInCartPerRecipeList);
                          List<IngredientInCartPerRecipeList> notBuyList =
                              cartListModel.createNotBuyList(
                                  ingredientListInCartPerRecipeList);

                          return Container(
                            child: ListView(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 8)
                                          .r,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '買う (${buyList.length})',
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .subtitle1,
                                        textAlign: TextAlign.left,
                                      ),
                                      TextButton.icon(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (_) {
                                                return _introductionOfMoveListDialog(
                                                    context);
                                              },
                                            );
                                          },
                                          icon: Icon(
                                            Icons.help_outline_rounded,
                                            color: Theme.of(context).hintColor,
                                            size: 20.sp,
                                          ),
                                          label: Text(
                                            '移動のやり方',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .hintColor),
                                          ))
                                    ],
                                  ),
                                ),
                                _ingredientListCardWidget(
                                    context, 'buyList', buyList),
                                Divider(
                                  thickness: 1,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 8)
                                          .r,
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Text(
                                            '買わない (${notBuyList.length})',
                                            style: Theme.of(context)
                                                .primaryTextTheme
                                                .subtitle1,
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        GestureDetector(
                                          child: notBuyIngredientListIsOpen ==
                                                  true
                                              ? Icon(Icons.expand_less_rounded)
                                              : Icon(Icons.expand_more_rounded),
                                          onTap: () {
                                            notBuyIngredientListIsOpenNotifier
                                                    .state =
                                                !notBuyIngredientListIsOpen;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                notBuyIngredientListIsOpen == true
                                    ? _ingredientListCardWidget(
                                        context, 'notBuyList', notBuyList)
                                    : SizedBox(
                                        height: (72 * notBuyList.length)
                                            .toDouble()
                                            .h,
                                      ),
                                SizedBox(
                                  height: 100.h,
                                ),
                              ],
                            ),
                          );
                        });
                  }),
            ),

            /// レシピタブ
            recipeListInCartStream.when(
                error: (error, stack) => Text('Error: $error'),
                loading: () => const CircularProgressIndicator(),
                data: (recipeListInCart) {
                  final _recipeList = recipeListInCart;
                  return ListView.builder(
                    itemCount: _recipeList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final _recipe = _recipeList[index];
                      return ListTile(
                        title: Text(
                          _recipe.recipeName!,
                          style: Theme.of(context).primaryTextTheme.subtitle1,
                        ),
                        subtitle: Text(
                          '${_recipe.countInCart! * _recipe.forHowManyPeople!}人分',
                          style: Theme.of(context).primaryTextTheme.caption,
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.chevron_right_rounded),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  fullscreenDialog: false,
                                  builder: (context) =>
                                      CartListRecipeDetailPage(
                                          _recipe.recipeId!),
                                ));
                          },
                        ),
                      );
                    },
                  );
                })
          ],
        ),
      ),
    );
  }

  Widget _ingredientListCardWidget(BuildContext context, String listType,
      List<IngredientInCartPerRecipeList> ingredientList) {
    CartListModel cartListModel = CartListModel();
    String _slidableActionText = listType == 'buyList' ? '買わないリストへ' : '買うリストへ';

    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: ingredientList.length,
        itemBuilder: (context, index) {
          final ingredient = ingredientList[index];
          final id = ingredient.ingredientInCart.ingredientName +
              ingredient.ingredientInCart.ingredientUnit;
          return Slidable(
            key: ValueKey(id),
            startActionPane: ActionPane(
              extentRatio: 0.4,
              motion: ScrollMotion(),
              children: [
                SlidableAction(
                  borderRadius: BorderRadius.circular(10),
                  label: _slidableActionText,
                  backgroundColor: Theme.of(context).primaryColor,
                  onPressed: (context) {
                    cartListModel.toggleIsNeed(
                      id,
                    );
                  },
                )
              ],
            ),
            child: CheckboxListTile(
              title: Text(
                '${ingredient.ingredientInCart.ingredientName}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: cartListModel.getCartItem(id).isBought
                        ? TextDecoration.lineThrough
                        : TextDecoration.none),
              ),
              subtitle: Text(
                '${ingredient.ingredientInCart.ingredientTotalAmount}${ingredient.ingredientInCart.ingredientUnit}',
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).primaryTextTheme.caption!.copyWith(
                    decoration: cartListModel.getCartItem(id).isBought
                        ? TextDecoration.lineThrough
                        : TextDecoration.none),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              value: cartListModel.getCartItem(id).isBought,
              onChanged: (isBought) {
                cartListModel.toggleIsBought(id, isBought!);
              },
              secondary: IconButton(
                icon: Icon(Icons.info_outline),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return _recipeListPerIngredientDialog(
                          context, ingredient);
                    },
                  );
                },
              ),
            ),
          );
        });
  }

  Widget _recipeListPerIngredientDialog(
      BuildContext context, IngredientInCartPerRecipeList ingredient) {
    return AlertDialog(
      title: Text(
        '${ingredient.ingredientInCart.ingredientName}を使うレシピ',
        style: Theme.of(context).primaryTextTheme.headline5,
      ),
      contentPadding: EdgeInsets.zero,
      content: Container(
        width: double.maxFinite,
        height: 200.h,
        child: ListView.builder(
          itemCount: ingredient.recipeForIngredientInCartList.length,
          itemBuilder: (context, recipeIndex) {
            final recipe =
                ingredient.recipeForIngredientInCartList[recipeIndex];
            return ListTile(
              title: Text(
                '${recipe.recipeName}',
                style: Theme.of(context).primaryTextTheme.subtitle1,
              ),
              subtitle: Text(
                '${recipe.forHowManyPeople * recipe.countInCart}人分  ${recipe.ingredientAmount}${ingredient.ingredientInCart.ingredientUnit}',
                style: Theme.of(context).primaryTextTheme.caption,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: IconButton(
                icon: Icon(Icons.chevron_right_rounded),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        fullscreenDialog: false,
                        builder: (context) =>
                            CartListRecipeDetailPage(recipe.recipeId),
                      ));
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _introductionOfMoveListDialog(BuildContext context) {
    return AlertDialog(
      title: Text(
        '移動のやり方',
        style: Theme.of(context).primaryTextTheme.headline5,
      ),
      contentPadding: EdgeInsets.zero,
      content: Container(
        width: double.maxFinite,
        height: 400.h,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 8).r,
          child: Column(
            children: [
              Text('移動したい材料を右へスクロールし、「買わない(買う)リストへ」をタップすると移動することができます'),
              SizedBox(
                height: 16.h,
              ),
              Image(
                width: double.infinity,
                image: AssetImage(
                    'lib/assets/introductions/intro_move_cart_list.gif'),
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
