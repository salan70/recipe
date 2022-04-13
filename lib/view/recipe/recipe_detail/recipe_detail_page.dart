import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:recipe/components/providers.dart';
import 'package:recipe/components/widgets/recipe_detail_widget/recipe_detail_widget.dart';
import 'package:recipe/view/recipe/recipe_detail/recipe_detail_model.dart';
import 'package:recipe/view/recipe/update_recipe/update_recipe_page.dart';

class RecipeDetailPage extends ConsumerWidget {
  RecipeDetailPage(this.recipeId, this.fromPageName);
  final String recipeId;
  final String fromPageName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider);

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
            return Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0),
              width: double.infinity,
              child: ListView(
                children: [
                  RecipeDetailWidget(recipeId, fromPageName),
                  Center(
                    child: TextButton(
                      child: Text(
                        'レシピを削除',
                      ),
                      onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text('確認'),
                          content: Text('本当にこのレシピを削除しますか？'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: Text('いいえ'),
                            ),
                            TextButton(
                              onPressed: () async {
                                //削除失敗
                                if (recipe.recipeId == null ||
                                    !await recipeDetailModel
                                        .deleteRecipe(recipe)) {
                                  final snackBar = SnackBar(
                                      content: const Text(
                                    'レシピの削除に失敗しました',
                                    textAlign: TextAlign.center,
                                  ));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                                //削除成功
                                else {
                                  Navigator.of(context)
                                      .popUntil((route) => route.isFirst);
                                  final snackBar = SnackBar(
                                      content: Text(
                                    '${recipe.recipeName}を削除しました',
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
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
