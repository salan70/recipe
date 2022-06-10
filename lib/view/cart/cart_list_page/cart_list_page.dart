import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:recipe/domain/cart.dart';
import 'package:recipe/domain/type_adapter/cart_item/cart_item.dart';
import 'package:recipe/state/other_provider/providers.dart';
import 'package:recipe/view/cart/cart_list_recipe_detail/cart_list_recipe_detail_page.dart';
import 'cart_list_model.dart';

class CartListPage extends ConsumerWidget {
  const CartListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartListModel = CartListModel();

    final recipeListInCartStream = ref.watch(recipeListInCartStreamProvider);
    final notBuyIngredientListIsOpen =
        ref.watch(notBuyIngredientListIsOpenProvider);
    final notBuyIngredientListIsOpenNotifier =
        ref.watch(notBuyIngredientListIsOpenProvider.notifier);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'カート',
          ),
          bottom: TabBar(
            indicatorColor: Theme.of(context).primaryColorDark,
            tabs: <Widget>[
              Tab(
                child: Text(
                  '材料',
                  style: Theme.of(context).primaryTextTheme.subtitle1,
                ),
              ),
              Tab(
                child: Text(
                  'レシピ',
                  style: Theme.of(context).primaryTextTheme.subtitle1,
                ),
              ),
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
                      final ingredientPerInCartRecipeList =
                          <IngredientByRecipeInCart>[];

                      for (final recipe in recipeListInCart) {
                        cartListModel
                            .createIngredientListByRecipeInCart(recipe)
                            .forEach(ingredientPerInCartRecipeList.add);
                      }

                      final ingredientListInCartPerRecipeList =
                          cartListModel.createTotaledIngredientListInCart(
                        ingredientPerInCartRecipeList,
                      );

                      final buyList = cartListModel
                          .createBuyList(ingredientListInCartPerRecipeList);
                      final notBuyList = cartListModel.createNotBuyList(
                        ingredientListInCartPerRecipeList,
                      );

                      return ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8).r,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    showDialog<Widget>(
                                      context: context,
                                      builder: (_) {
                                        return _introductionOfMoveListDialog(
                                          context,
                                        );
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
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          _ingredientListCardWidget(
                            context,
                            'buyList',
                            buyList,
                          ),
                          const Divider(
                            thickness: 1,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8).r,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '買わない (${notBuyList.length})',
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .subtitle1,
                                  textAlign: TextAlign.left,
                                ),
                                GestureDetector(
                                  child: notBuyIngredientListIsOpen == true
                                      ? const Icon(
                                          Icons.expand_less_rounded,
                                        )
                                      : const Icon(
                                          Icons.expand_more_rounded,
                                        ),
                                  onTap: () {
                                    notBuyIngredientListIsOpenNotifier.state =
                                        !notBuyIngredientListIsOpen;
                                  },
                                ),
                              ],
                            ),
                          ),
                          notBuyIngredientListIsOpen == true
                              ? _ingredientListCardWidget(
                                  context,
                                  'notBuyList',
                                  notBuyList,
                                )
                              : SizedBox(
                                  height: (72 * notBuyList.length).toDouble().h,
                                ),
                          SizedBox(
                            height: 100.h,
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),

            /// レシピタブ
            recipeListInCartStream.when(
              error: (error, stack) => Text('Error: $error'),
              loading: () => const CircularProgressIndicator(),
              data: (recipeListInCart) {
                final recipeList = recipeListInCart;
                return ListView.builder(
                  itemCount: recipeList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final recipe = recipeList[index];
                    return ListTile(
                      title: Text(
                        recipe.recipeName!,
                        style: Theme.of(context).primaryTextTheme.subtitle1,
                      ),
                      subtitle: Text(
                        '${recipe.countInCart! * recipe.forHowManyPeople!}人分',
                        style: Theme.of(context).primaryTextTheme.caption,
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.chevron_right_rounded),
                        onPressed: () {
                          Navigator.push<MaterialPageRoute<dynamic>>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CartListRecipeDetailPage(
                                recipeId: recipe.recipeId!,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _ingredientListCardWidget(
    BuildContext context,
    String listType,
    List<TotaledIngredientInCart> ingredientList,
  ) {
    final cartListModel = CartListModel();
    final slidableActionText = listType == 'buyList' ? '買わないへ' : '買うへ';

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: ingredientList.length,
      itemBuilder: (context, index) {
        final ingredient = ingredientList[index];
        final ingredientInCart = ingredient.ingredientInCart;
        final id = ingredient.ingredientInCart.ingredientName +
            ingredient.ingredientInCart.ingredientUnit;
        return Slidable(
          key: ValueKey(id),
          startActionPane: ActionPane(
            extentRatio: 0.4,
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                borderRadius: BorderRadius.circular(10),
                label: slidableActionText,
                backgroundColor: Theme.of(context).primaryColor,
                onPressed: (context) {
                  cartListModel.toggleIsInBuyList(
                    id,
                  );
                },
              )
            ],
          ),
          child: CheckboxListTile(
            title: Text(
              ingredientInCart.ingredientName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: cartListModel.getCartItem(id).isChecked
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            subtitle: Text(
              '${ingredientInCart.ingredientTotalAmount}'
              '${ingredientInCart.ingredientUnit}',
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).primaryTextTheme.caption!.copyWith(
                    decoration: cartListModel.getCartItem(id).isChecked
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
            ),
            controlAffinity: ListTileControlAffinity.leading,
            value: cartListModel.getCartItem(id).isChecked,
            onChanged: (isChecked) {
              cartListModel.toggleIsChecked(id, isChecked!);
            },
            secondary: IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                showDialog<Widget>(
                  context: context,
                  builder: (_) {
                    return _recipeListPerIngredientDialog(
                      context,
                      ingredient,
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _recipeListPerIngredientDialog(
    BuildContext context,
    TotaledIngredientInCart ingredient,
  ) {
    return AlertDialog(
      title: Text(
        '${ingredient.ingredientInCart.ingredientName}を使うレシピ',
        style: Theme.of(context).primaryTextTheme.headline5,
      ),
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        width: double.maxFinite,
        height: 200.h,
        child: ListView.builder(
          itemCount: ingredient.recipeListByIngredientInCart.length,
          itemBuilder: (context, recipeIndex) {
            final recipe = ingredient.recipeListByIngredientInCart[recipeIndex];
            return ListTile(
              title: Text(
                recipe.recipeName,
                style: Theme.of(context).primaryTextTheme.subtitle1,
              ),
              subtitle: Text(
                '${recipe.forHowManyPeople * recipe.countInCart}人分  '
                '${recipe.ingredientAmount}'
                '${ingredient.ingredientInCart.ingredientUnit}',
                style: Theme.of(context).primaryTextTheme.caption,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: IconButton(
                icon: const Icon(Icons.chevron_right_rounded),
                onPressed: () {
                  Navigator.push<MaterialPageRoute<dynamic>>(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CartListRecipeDetailPage(recipeId: recipe.recipeId),
                    ),
                  );
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
      content: SizedBox(
        width: double.maxFinite,
        height: 400.h,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 8).r,
          child: Column(
            children: [
              const Text('移動したい材料を右へスクロールし、「買わない(買う)へ」をタップすると移動することができます'),
              SizedBox(
                height: 16.h,
              ),
              const Image(
                width: double.infinity,
                image: AssetImage(
                  'lib/assets/introductions/intro_move_cart_list.gif',
                ),
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
