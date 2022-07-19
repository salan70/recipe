import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:recipe/domain/cart.dart';
import 'package:recipe/state/auth/auth_provider.dart';
import 'package:recipe/state/other_provider/providers.dart';
import 'package:recipe/view/cart/cart_list/cart_list_model.dart';
import 'package:recipe/view/cart/cart_recipe_detail/cart_recipe_detail_page.dart';
import 'package:recipe/view/setting/setting_top/setting_top_page.dart';

class CartListPage extends ConsumerWidget {
  const CartListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipeListInCartStream = ref.watch(recipeListInCartProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        leading: IconButton(
          icon: const Icon(
            Icons.settings_rounded,
          ),
          onPressed: () {
            pushNewScreen<dynamic>(
              context,
              screen: const SettingTopPage(),
              withNavBar: false,
            );
          },
        ),
        title: const Text(
          'カート',
        ),
        actions: [
          recipeListInCartStream.when(
            error: (error, stack) => const Text('Error'),
            loading: () => const CircularProgressIndicator(),
            data: (recipeListInCart) {
              return recipeListInCart.isEmpty
                  ? const SizedBox()
                  : TextButton(
                      child: Text(
                        '空にする',
                        style: TextStyle(color: Theme.of(context).errorColor),
                      ),
                      onPressed: () {
                        showDialog<AlertDialog>(
                          context: context,
                          builder: (context) => ConfirmAllDeleteDialog(
                            recipeListInCart: recipeListInCart,
                          ),
                        );
                      },
                    );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          recipeListInCartStream.when(
            error: (error, stack) => Text('Error: $error'),
            loading: () => const CircularProgressIndicator(),
            data: (recipeListInCart) {
              return recipeListInCart.isEmpty
                  ? Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 24).r,
                      child: Text(
                        'カートが空です。\n「レシピ」>「レシピ詳細」からレシピをカートに追加することができます。',
                        style: Theme.of(context).textTheme.subtitle1,
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: recipeListInCart.length,
                      itemBuilder: (context, index) {
                        final recipe = recipeListInCart[index];
                        return SizedBox(
                          height: 160.h,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push<MaterialPageRoute<dynamic>>(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CartRecipeDetailPage(
                                    recipeId: recipe.recipeId!,
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 8,
                                  right: 8,
                                  left: 8,
                                ).r,
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: SizedBox(
                                        width: 160.w,
                                        height: 96.h,
                                        child: recipe.imageUrl != null
                                            ? recipe.imageUrl != ''
                                                ? Image.network(
                                                    recipe.imageUrl!,
                                                    errorBuilder: (c, o, s) {
                                                      return const Icon(
                                                        Icons.error,
                                                      );
                                                    },
                                                  )
                                                : DecoratedBox(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        8,
                                                      ).r,
                                                      color: Theme.of(context)
                                                          .dividerColor,
                                                    ),
                                                    child: const Icon(
                                                      Icons.restaurant_rounded,
                                                    ),
                                                  )
                                            : const CircularProgressIndicator(),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8.w,
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          /// レシピ名
                                          Text(
                                            recipe.recipeName!,
                                            maxLines: 2,
                                            textAlign: TextAlign.left,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2,
                                          ),
                                          const Spacer(),

                                          /// 「○人分 × ドロップダウン」
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                '${recipe.forHowManyPeople}人分 ×',
                                                maxLines: 2,
                                                textAlign: TextAlign.left,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1,
                                              ),
                                              SizedBox(
                                                width: 8.w,
                                              ),
                                              CountDropdownButton(
                                                initialCount:
                                                    recipe.countInCart!,
                                                recipe: recipe,
                                              ),
                                              SizedBox(
                                                width: 8.w,
                                              ),
                                            ],
                                          ),

                                          /// 削除ボタン
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: TextButton(
                                              child: Text(
                                                '削除',
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .errorColor,
                                                ),
                                              ),
                                              onPressed: () {
                                                showDialog<AlertDialog>(
                                                  context: context,
                                                  builder: (context) =>
                                                      ConfirmDeleteDialog(
                                                    recipe: recipe,
                                                  ),
                                                );
                                              },
                                              // ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
            },
          ),
          SizedBox(
            height: 24.h,
          )
        ],
      ),
    );
  }
}

class ConfirmAllDeleteDialog extends ConsumerWidget {
  const ConfirmAllDeleteDialog({Key? key, required this.recipeListInCart})
      : super(key: key);

  final List<RecipeInCart> recipeListInCart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userStateNotifierProvider);
    final cartListModel = CartListModel(user: user!);

    return AlertDialog(
      title: const Text('確認'),
      content: const Text('本当にカートを空にしてよろしいですか？'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('いいえ'),
        ),
        TextButton(
          onPressed: () async {
            await EasyLoading.show(status: 'loading...');
            final errorText = await cartListModel.deleteAllRecipeFromCart(
              recipeListInCart,
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
    );
  }
}

class ConfirmDeleteDialog extends ConsumerWidget {
  const ConfirmDeleteDialog({Key? key, required this.recipe}) : super(key: key);

  final RecipeInCart recipe;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userStateNotifierProvider);
    final cartListModel = CartListModel(user: user!);

    return AlertDialog(
      title: const Text('確認'),
      content: const Text('本当にカートから削除してよろしいですか？'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('いいえ'),
        ),
        TextButton(
          onPressed: () async {
            await EasyLoading.show(
              status: 'loading...',
            );
            final errorText = await cartListModel.updateCountInCart(
              recipeId: recipe.recipeId!,
              countInCart: 0,
            );
            if (errorText == null) {
              Navigator.pop(context);
              await EasyLoading.showSuccess(
                'カートから削除しました',
              );
              // selectedCountNotifier.state = value;
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
          child: const Text('はい'),
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
    final cartListModel = CartListModel(user: user!);
    final selectedCount = ref.watch(selectedCountProviderFamily(initialCount));
    final selectedCountNotifier =
        ref.watch(selectedCountProviderFamily(initialCount).notifier);

    return CustomDropdownButton2(
      icon: const Icon(Icons.arrow_drop_down),
      iconSize: 24.sp,
      buttonWidth: 72.w,
      dropdownHeight: 300.h,
      dropdownWidth: 120.w,
      buttonPadding: const EdgeInsets.only(left: 16),
      hint: 'Select Item',
      dropdownItems: cartListModel.countList,
      value: selectedCount,
      onChanged: (value) async {
        await EasyLoading.show(status: 'loading...');
        if (value != null) {
          final errorText = await cartListModel.updateCountInCart(
            recipeId: recipe.recipeId!,
            countInCart: recipe.countInCart!,
          );
          if (errorText == null) {
            await EasyLoading.showSuccess('更新しました');
            selectedCountNotifier.state = value;
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
        }
      },
    );
  }
}
