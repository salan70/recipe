import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:recipe/components/providers.dart';
import 'package:recipe/components/widgets/recipe_detail_widget/recipe_detail_widget.dart';
import 'package:recipe/state/auth/auth_provider.dart';
import 'package:recipe/view/recipe/recipe_detail/recipe_detail_model.dart';
import 'package:recipe/view/recipe/update_recipe/update_recipe_page.dart';

class RecipeDetailPage extends ConsumerWidget {
  RecipeDetailPage(this.recipeId, this.fromPageName);
  final String recipeId;
  final String fromPageName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userStateNotifierProvider);

    final recipe = ref.watch(recipeStreamProviderFamily(recipeId));

    RecipeDetailModel recipeDetailModel = RecipeDetailModel(user: user!);

    return Scaffold(
      appBar: recipe.when(
          error: (error, stack) => AppBar(
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios),
                ),
                title: Text('エラー'),
              ),
          loading: () => AppBar(
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios),
                ),
              ),
          data: (recipe) {
            return AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios),
              ),
              title: Text(
                'レシピの詳細',
              ),
              actions: <Widget>[
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateRecipePage(recipe),
                            fullscreenDialog: true,
                          ));
                    },
                    icon: Icon(Icons.edit))
              ],
            );
          }),
      body: recipe.when(
          error: (error, stack) => Text('Error: $error'),
          loading: () => const CircularProgressIndicator(),
          data: (recipe) {
            return ListView(
              children: [
                RecipeDetailWidget(recipeId),
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
                    onPressed: () => showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('確認'),
                            content: Text('本当にこのレシピを削除しますか？'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('キャンセル'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              TextButton(
                                child: Text('はい'),
                                onPressed: () async {
                                  EasyLoading.show(status: 'loading...');
                                  //削除失敗
                                  if (recipe.recipeId == null ||
                                      !await recipeDetailModel
                                          .deleteRecipe(recipe)) {
                                    EasyLoading.showError('レシピの削除に失敗しました');
                                  }
                                  //削除成功
                                  else {
                                    Navigator.of(context)
                                        .popUntil((route) => route.isFirst);
                                    EasyLoading.showSuccess(
                                        '${recipe.recipeName}を削除しました');
                                  }
                                },
                              ),
                            ],
                          );
                        }),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
