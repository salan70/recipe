import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:recipe/components/widgets/recipe_detail_widget/recipe_detail_widget.dart';
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
                      // TODO カートに追加するようの処理（ダイアログ？）
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
