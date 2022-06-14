import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

    final recipeDetailModel = RecipeDetailModel(user: user!);

    return Scaffold(
      appBar: recipe.when(
        error: (error, stack) => AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          title: const Text('エラー'),
        ),
        loading: () => AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        data: (recipe) {
          return AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios),
            ),
            title: const Text(
              'レシピの詳細',
            ),
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.push<MaterialPageRoute<dynamic>>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdateRecipePage(recipe: recipe),
                      fullscreenDialog: true,
                    ),
                  );
                },
                icon: const Icon(Icons.edit),
              )
            ],
          );
        },
      ),
      body: recipe.when(
        error: (error, stack) => Text('Error: $error'),
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
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('確認'),
                        content: const Text('本当にこのレシピを削除しますか？'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('キャンセル'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: const Text('はい'),
                            onPressed: () async {
                              await EasyLoading.show(status: 'loading...');
                              //削除失敗
                              if (recipe.recipeId == null ||
                                  !await recipeDetailModel
                                      .deleteRecipe(recipe)) {
                                await EasyLoading.showError('レシピの削除に失敗しました');
                              }
                              //削除成功
                              else {
                                await EasyLoading.showSuccess(
                                  '${recipe.recipeName}を削除しました',
                                );
                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst);
                              }
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
