import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:recipe/domain/buy_list.dart';
import 'package:recipe/domain/type_adapter/cart_item/cart_item.dart';
import 'package:recipe/state/auth/auth_provider.dart';
import 'package:recipe/state/other_provider/providers.dart';
import 'package:recipe/view/buy_list/buy_list_recipe_detail/buy_list_recipe_detail_page.dart';
import 'package:recipe/view/buy_list/ingredient_tab/ingredient_tab_model.dart';

class IngredientTabWidget extends ConsumerWidget {
  const IngredientTabWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ingredientTabModel = IngredientTabModel();

    final user = ref.watch(userStateNotifierProvider);
    final recipeListInCart = ref.watch(recipeListInCartProvider);
    final notBuyListIsOpen = ref.watch(notBuyListIsOpenProvider);
    final notBuyListIsOpenNotifier =
        ref.watch(notBuyListIsOpenProvider.notifier);

    final selectedTabContext = context;

    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 8, right: 8).r,
      child: ValueListenableBuilder(
        valueListenable: CartItemBoxes.getCartItems().listenable(),
        builder: (context, box, widget) {
          return recipeListInCart.when(
            error: (error, stack) => Text('Error: $error'),
            loading: () => const CircularProgressIndicator(),
            data: (recipeListInCart) {
              final totaledIngredientList = ingredientTabModel
                  .castToTotaledIngredientList(recipeListInCart);

              final ingredientBuyList =
                  ingredientTabModel.createIngredientBuyList(
                totaledIngredientList,
              );
              final ingredientNotBuyList =
                  ingredientTabModel.createIngredientNotBuyList(
                totaledIngredientList,
              );

              final otherCartItemList = ref.watch(otherBuyListItemListProvider);

              var otherItemBuyList = <OtherBuyListItem>[];
              var otherItemNotBuyList = <OtherBuyListItem>[];

              var countBuyList = ingredientBuyList.length;
              var countNotBuyList = ingredientNotBuyList.length;

              otherCartItemList.when(
                error: (error, stack) => Text('Error: $error'),
                loading: () => const CircularProgressIndicator(),
                data: (data) {
                  otherItemBuyList =
                      ingredientTabModel.createOtherItemBuyList(data);
                  otherItemNotBuyList =
                      ingredientTabModel.createOtherItemNotBuyList(data);

                  countBuyList += otherItemBuyList.length;
                  countNotBuyList += otherItemNotBuyList.length;
                },
              );

              return ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8).r,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '買う ($countBuyList)',
                          style: Theme.of(context).textTheme.subtitle2,
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
                  _ingredientListViewWidget(
                    context,
                    selectedTabContext,
                    'buyList',
                    ingredientBuyList,
                  ),
                  _otherItemListViewWidget(
                    context,
                    'buyList',
                    otherItemBuyList,
                    user!,
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
                          '買わない ($countNotBuyList)',
                          style: Theme.of(context).textTheme.subtitle2,
                          textAlign: TextAlign.left,
                        ),
                        GestureDetector(
                          child: notBuyListIsOpen == true
                              ? const Icon(
                                  Icons.expand_less_rounded,
                                )
                              : const Icon(
                                  Icons.expand_more_rounded,
                                ),
                          onTap: () {
                            notBuyListIsOpenNotifier.state = !notBuyListIsOpen;
                          },
                        ),
                      ],
                    ),
                  ),
                  notBuyListIsOpen == true
                      ? Column(
                          children: [
                            _ingredientListViewWidget(
                              context,
                              selectedTabContext,
                              'notBuyList',
                              ingredientNotBuyList,
                            ),
                            _otherItemListViewWidget(
                              context,
                              'notBuyList',
                              otherItemNotBuyList,
                              user,
                            ),
                          ],
                        )
                      : SizedBox(
                          height:
                              (72 * ingredientNotBuyList.length).toDouble().h,
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
    );
  }

  Widget _ingredientListViewWidget(
    BuildContext context,
    BuildContext selectedTabContext,
    String listType,
    List<TotaledIngredient> ingredientList,
  ) {
    final ingredientTabModel = IngredientTabModel();
    final slidableActionText = listType == 'buyList' ? '買わないへ' : '買うへ';

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: ingredientList.length,
      itemBuilder: (context, index) {
        final ingredient = ingredientList[index];
        final ingredientInCart = ingredient.ingredientInCart;
        final id =
            ingredient.ingredientInCart.name + ingredient.ingredientInCart.unit;

        return Slidable(
          key: ValueKey(id),
          startActionPane: ActionPane(
            extentRatio: 0.4,
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                label: slidableActionText,
                backgroundColor: Theme.of(context).primaryColor,
                onPressed: (context) {
                  ingredientTabModel.toggleIsInBuyList(
                    id,
                  );
                },
              )
            ],
          ),
          child: CheckboxListTile(
            title: Text(
              ingredientInCart.name,
              style: Theme.of(context).textTheme.subtitle2!.copyWith(
                    decoration: ingredientTabModel.getCartItem(id).isChecked
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
            ),
            subtitle: Text(
              '${ingredientInCart.totalAmount}'
              '${ingredientInCart.unit}',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                decoration: ingredientTabModel.getCartItem(id).isChecked
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            controlAffinity: ListTileControlAffinity.leading,
            value: ingredientTabModel.getCartItem(id).isChecked,
            onChanged: (isChecked) {
              ingredientTabModel.toggleIsChecked(id: id, isChecked: isChecked!);
            },
            secondary: IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                showDialog<Widget>(
                  context: context,
                  builder: (_) {
                    return _recipeListPerIngredientDialog(
                      selectedTabContext,
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

  Widget _otherItemListViewWidget(
    BuildContext context,
    String listType,
    List<OtherBuyListItem> otherItemList,
    User user,
  ) {
    final ingredientTabModel = IngredientTabModel();
    final slidableActionText = listType == 'buyList' ? '買わないへ' : '買うへ';

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: otherItemList.length,
      itemBuilder: (context, index) {
        final otherItem = otherItemList[index];
        final id = otherItem.itemId;

        return Slidable(
          key: ValueKey(id),
          startActionPane: ActionPane(
            extentRatio: 0.4,
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                label: slidableActionText,
                backgroundColor: Theme.of(context).primaryColor,
                onPressed: (context) {
                  ingredientTabModel.toggleIsInBuyList(
                    id!,
                  );
                },
              )
            ],
          ),
          endActionPane: ActionPane(
            extentRatio: 0.4,
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                label: '削除',
                backgroundColor: Theme.of(context).errorColor,
                onPressed: (context) async {
                  await EasyLoading.show(status: 'loading...');
                  final errorText =
                      await ingredientTabModel.deleteOtherBuyListItem(
                    user,
                    otherItem.itemId!,
                  );
                  if (errorText == null) {
                    await EasyLoading.showSuccess(
                      '${otherItem.title}を削除しました',
                    );
                  } else {
                    await EasyLoading.showError(
                      errorText,
                    );
                  }
                },
              )
            ],
          ),
          child: CheckboxListTile(
            title: Text(
              otherItem.title,
              style: Theme.of(context).textTheme.subtitle2!.copyWith(
                    decoration: ingredientTabModel.getCartItem(id!).isChecked
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
            ),
            subtitle: Text(
              otherItem.subTitle,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption!.copyWith(
                    decoration: ingredientTabModel.getCartItem(id).isChecked
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
            ),
            controlAffinity: ListTileControlAffinity.leading,
            value: ingredientTabModel.getCartItem(id).isChecked,
            onChanged: (isChecked) {
              ingredientTabModel.toggleIsChecked(
                id: id,
                isChecked: isChecked!,
              );
            },
          ),
        );
      },
    );
  }

  Widget _recipeListPerIngredientDialog(
    BuildContext selectedTabContext,
    TotaledIngredient ingredient,
  ) {
    return AlertDialog(
      title: Text(
        '${ingredient.ingredientInCart.name}を使うレシピ',
      ),
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        width: double.maxFinite,
        height: 200.h,
        child: ListView.builder(
          itemCount: ingredient.recipeListPerIngredient.length,
          itemBuilder: (context, recipeIndex) {
            final recipe = ingredient.recipeListPerIngredient[recipeIndex];
            return ListTile(
              title: Text(
                recipe.recipeName,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              subtitle: Text(
                '${recipe.forHowManyPeople * recipe.countInCart}人分  '
                '${recipe.ingredientAmount}'
                '${ingredient.ingredientInCart.unit}',
                style: Theme.of(context).textTheme.caption,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: IconButton(
                icon: const Icon(Icons.chevron_right_rounded),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push<MaterialPageRoute<dynamic>>(
                    selectedTabContext,
                    MaterialPageRoute(
                      builder: (context) =>
                          BuyListRecipeDetailPage(recipeId: recipe.recipeId),
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
        style: Theme.of(context).textTheme.headline5,
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
