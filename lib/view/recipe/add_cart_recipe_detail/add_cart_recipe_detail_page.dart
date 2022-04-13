import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:recipe/components/providers.dart';
import 'package:recipe/components/widgets/recipe_detail_widget/recipe_detail_widget.dart';
import 'package:recipe/view/recipe/update_recipe/update_recipe_page.dart';

import 'add_cart_recipe_detail_model.dart';

class AddBasketRecipeDetailPage extends ConsumerWidget {
  AddBasketRecipeDetailPage(this.recipeId, this.fromPageName);
  final String recipeId;
  final String fromPageName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider);
    AddCartRecipeDetailModel addCartRecipeDetailModel =
        AddCartRecipeDetailModel(user: user!);

    final recipe = ref.watch(recipeStreamProviderFamily(recipeId));

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
              elevation: 1,
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: recipe.when(
                  error: (error, stack) => Text('Error: $error'),
                  loading: () => const CircularProgressIndicator(),
                  data: (recipe) {
                    return Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 20.0, right: 20.0),
                          width: double.infinity,
                          child: RecipeDetailWidget(
                              recipeId, 'add_cart_recipe_detail_page'),
                        ),
                      ],
                    );
                  }),
            ),
          ),
          recipe.when(
              error: (error, stack) => Text('Error: $error'),
              loading: () => const CircularProgressIndicator(),
              data: (recipe) {
                final counter =
                    ref.watch(recipeNumCountProviderFamily(recipe.countInCart));
                final counterNotifier = ref.watch(
                    recipeNumCountProviderFamily(recipe.countInCart).notifier);
                return Column(
                  children: [
                    _counterWidget(
                        recipe.forHowManyPeople!, counter, counterNotifier),
                    Container(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (counter == 0) {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: Text('確認'),
                                content: Text('数量が0ですがよろしいですか？'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Cancel'),
                                    child: Text('いいえ'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      print('はい');
                                      await addCartRecipeDetailModel
                                          .updateCount(recipeId, counter);
                                      int popInt = 0;
                                      Navigator.popUntil(
                                          context, (_) => popInt++ >= 2);
                                    },
                                    child: Text('はい'),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            await addCartRecipeDetailModel.updateCount(
                                recipeId, counter);
                            Navigator.pop(context);
                          }
                        },
                        child: Text('確定'),
                      ),
                    ),
                  ],
                );
              }),
        ],
      ),
    );
  }

  Widget _counterWidget(
      int fowHowManyPeople, int counter, StateController<int> counterNotifier) {
    return SizedBox(
        height: 160,
        child: Row(
          children: [
            Expanded(child: Text('合計${fowHowManyPeople * counter}人分')),
            Expanded(
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        if (counter > 0) {
                          counterNotifier.state--;
                        }
                      },
                      icon: counter == 0
                          ? Icon(Icons.remove_circle_outline)
                          : Icon(Icons.remove_circle)),
                  Text('× $counter'),
                  IconButton(
                      onPressed: () {
                        counterNotifier.state++;
                      },
                      icon: Icon(Icons.add_circle))
                ],
              ),
            ),
          ],
        ));
  }
}
