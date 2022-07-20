import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:recipe/components/widgets/recipe_detail_widget/recipe_detail_widget.dart';
import 'package:recipe/domain/cart.dart';
import 'package:recipe/domain/recipe.dart';
import 'package:recipe/state/auth/auth_provider.dart';
import 'package:recipe/state/other_provider/providers.dart';
import 'package:recipe/view/recipe/recipe_detail/recipe_detail_model.dart';
import 'package:recipe/view/recipe/update_recipe/update_recipe_page.dart';

class RecipeDetailPage extends ConsumerWidget {
  const RecipeDetailPage({
    Key? key,
    required this.recipeId,
    required this.fromPageName,
  }) : super(key: key);
  final String recipeId;
  final String fromPageName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userStateNotifierProvider);

    final recipe = ref.watch(recipeProviderFamily(recipeId));

    final isLoading = ref.watch(isLoadingProvider);
    final isLoadingNotifier = ref.watch(isLoadingProvider.notifier);

    final recipeDetailModel = RecipeDetailModel(user: user!);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text(
          'レシピ詳細',
        ),
        actions: <Widget>[
          recipe.when(
            error: (error, stack) => Container(),
            loading: () => Container(),
            data: (recipe) {
              return Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add_shopping_cart_rounded),
                    onPressed: () {
                      showDialog<AlertDialog>(
                        context: context,
                        builder: (context) => SelectCountInCartDialog(
                          recipe: recipe,
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      pushNewScreen<dynamic>(
                        context,
                        screen: UpdateRecipePage(recipe: recipe),
                        withNavBar: false,
                        pageTransitionAnimation:
                            PageTransitionAnimation.slideUp,
                      );
                    },
                  ),
                ],
              );
            },
          )
        ],
      ),
      body: isLoading == true
          ? Container()
          : recipe.when(
              error: (error, stack) => Text('エラー: $error'),
              loading: () => const CircularProgressIndicator(),
              data: (recipe) {
                return ListView(
                  children: [
                    RecipeDetailWidget(recipeId: recipeId),
                    Center(
                      child: TextButton.icon(
                        icon: Icon(
                          Icons.delete_rounded,
                          color: Theme.of(context).errorColor,
                        ),
                        label: Text(
                          'レシピを削除',
                          style: TextStyle(color: Theme.of(context).errorColor),
                        ),
                        onPressed: () => showDialog<AlertDialog>(
                          context: context,
                          builder: (contextForDialog) {
                            return AlertDialog(
                              title: const Text('確認'),
                              content: const Text('本当にこのレシピを削除しますか？'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('キャンセル'),
                                  onPressed: () {
                                    Navigator.pop(contextForDialog);
                                  },
                                ),
                                TextButton(
                                  child: const Text('はい'),
                                  onPressed: () async {
                                    isLoadingNotifier.state = true;
                                    await EasyLoading.show(
                                      status: 'loading...',
                                    );
                                    //削除失敗
                                    if (recipe.recipeId == null ||
                                        !await recipeDetailModel
                                            .deleteRecipe(recipe)) {
                                      isLoadingNotifier.state = false;
                                      await EasyLoading.showError(
                                        'レシピの削除に失敗しました',
                                      );
                                    }
                                    //削除成功
                                    else {
                                      await EasyLoading.showSuccess(
                                        '${recipe.recipeName}を削除しました',
                                      );
                                      Navigator.pop(contextForDialog);
                                      Navigator.pop(context);
                                    }
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 24.h,
                    ),
                  ],
                );
              },
            ),
    );
  }
}

class SelectCountInCartDialog extends ConsumerWidget {
  const SelectCountInCartDialog({Key? key, required this.recipe})
      : super(key: key);

  final Recipe recipe;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userStateNotifierProvider);
    final selectedCount = ref.watch(selectedCountProvider);

    final recipeDetailModel = RecipeDetailModel(user: user!);
    final recipeInCart = RecipeInCart(
      recipeId: recipe.recipeId,
      recipeName: recipe.recipeName,
      imageUrl: recipe.imageUrl,
      forHowManyPeople: recipe.forHowManyPeople,
      countInCart: recipe.countInCart,
      ingredientList: recipe.ingredientList,
    );
    return AlertDialog(
      title: const Text('更新'),
      content: SizedBox(
        height: 120.h,
        child: Column(
          children: [
            const Text('カート内の数をいくつにしますか？'),
            SizedBox(
              height: 8.h,
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '${recipeInCart.forHowManyPeople}人分 ×',
                  maxLines: 2,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                SizedBox(
                  width: 8.w,
                ),
                CountDropdownButton(
                  initialCount: recipeInCart.countInCart!,
                  recipe: recipeInCart,
                ),
                SizedBox(
                  width: 8.w,
                ),
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('いいえ'),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: const Text('はい'),
          onPressed: () async {
            await EasyLoading.show(status: 'loading...');
            final countInCart =
                selectedCount == '' ? 1 : int.parse(selectedCount);
            final errorText = await recipeDetailModel.updateCountInCart(
              recipeId: recipe.recipeId!,
              countInCart: countInCart,
            );
            if (errorText == null) {
              Navigator.pop(context);
              await EasyLoading.showSuccess('更新しました');
            } else {
              await EasyLoading.dismiss();
              await showDialog<AlertDialog>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('更新失敗'),
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
        ),
      ],
    );
  }
}

class CountDropdownButton extends ConsumerWidget {
  const CountDropdownButton({
    Key? key,
    required this.initialCount,
    required this.recipe,
  }) : super(key: key);

  final int initialCount;
  final RecipeInCart recipe;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userStateNotifierProvider);

    final selectedCount = ref.watch(selectedCountProvider);
    final selectedCountNotifier = ref.watch(selectedCountProvider.notifier);
    final recipeDetailModel = RecipeDetailModel(user: user!);

    return CustomDropdownButton2(
      icon: const Icon(Icons.arrow_drop_down),
      iconSize: 24.sp,
      buttonWidth: 72.w,
      dropdownHeight: 300.h,
      dropdownWidth: 120.w,
      buttonPadding: const EdgeInsets.only(left: 16),
      hint: 'Select Item',
      dropdownItems: recipeDetailModel.countList,
      value: selectedCount == ''
          ? recipe.countInCart == 0
              ? '1'
              : recipe.countInCart.toString()
          : selectedCount,
      onChanged: (value) async {
        if (value != null) {
          selectedCountNotifier.state = value;
        }
      },
    );
  }
}
