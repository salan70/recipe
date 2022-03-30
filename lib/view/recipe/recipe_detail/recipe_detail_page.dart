import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:recipe/components/providers.dart';
import 'package:recipe/domain/recipe.dart';
import 'package:recipe/view/recipe_detail/recipe_detail_model.dart';
import 'package:recipe/view/update_recipe/update_recipe_page.dart';

class RecipeDetailPage extends ConsumerWidget {
  RecipeDetailPage(this.recipeId);
  final String recipeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider);

    final recipe = ref.watch(recipeStreamProviderFamily(recipeId));

    final ingredientList =
        ref.watch(ingredientListStreamProviderFamily(recipeId));

    final procedureList =
        ref.watch(procedureListStreamProviderFamily(recipeId));

    final ingredientListNotifier =
        ref.watch(ingredientListNotifierProvider.notifier);
    final procedureListNotifier =
        ref.watch(procedureListNotifierProvider.notifier);

    RecipeDetailModel recipeDetailModel = RecipeDetailModel(user: user!);

    return Scaffold(
      appBar: recipe.when(
          error: (error, stack) => AppBar(),
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
              title: Center(
                child: Hero(
                  tag: 'recipeList recipeName' + recipe.recipeId!,
                  child:
                      Text(recipe.recipeName!, overflow: TextOverflow.ellipsis),
                ),
              ),
              actions: <Widget>[
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateRecipeScreen(recipe),
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
                  SizedBox(height: 20),
                  // 画像
                  SizedBox(
                    height: 250,
                    child: Hero(
                      tag: 'recipeList recipeImage' + recipeId,
                      child: recipe.imageUrl != ''
                          ? Image.network(
                              recipe.imageUrl!,
                              errorBuilder: (c, o, s) {
                                return const Icon(
                                  Icons.error,
                                );
                              },
                            )
                          : Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Colors.grey[400],
                              ),
                              child: Icon(Icons.add_photo_alternate_outlined),
                            ),
                    ),
                  ),
                  // 評価
                  Center(
                      child: RatingBar.builder(
                    ignoreGestures: true,
                    initialRating: recipe.recipeGrade!,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {},
                  )),

                  // 材料
                  Column(
                    children: [
                      Row(children: [
                        Text("材料"),
                        SizedBox(width: 10),
                        Text(
                          recipe.forHowManyPeople.toString(),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text("人分"),
                      ]),
                      ingredientList.when(
                        error: (error, stack) => Text('Error: $error'),
                        loading: () => const CircularProgressIndicator(),
                        data: (ingredientList) {
                          if (ingredientList.isEmpty == false) {
                            WidgetsBinding.instance!.addPostFrameCallback((_) {
                              ingredientListNotifier.getList(ingredientList);
                            });
                          }
                          return ListView.builder(
                            itemCount: ingredientList.length,
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  Text(ingredientList[index].name.toString()),
                                  Text(ingredientList[index].amount.toString()),
                                  Text(ingredientList[index].unit.toString()),
                                ],
                              );
                            },
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // 手順
                  procedureList.when(
                      error: (error, stack) => Text('Error: $error'),
                      loading: () => const CircularProgressIndicator(),
                      data: (procedureList) {
                        if (procedureList.isEmpty == false) {
                          WidgetsBinding.instance!.addPostFrameCallback((_) {
                            procedureListNotifier.getList(procedureList);
                          });
                        }
                        return Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text("手順"),
                            ),
                            ListView.builder(
                              itemCount: procedureList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Row(
                                  children: [
                                    Text((index + 1).toString()),
                                    Text(procedureList[index]
                                        .content
                                        .toString()),
                                  ],
                                );
                              },
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                            ),
                          ],
                        );
                      }),
                  SizedBox(height: 20),
                  // メモ
                  Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text("メモ"),
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          child: recipe.recipeMemo != null
                              ? Text(recipe.recipeMemo!)
                              : Text('')),
                    ],
                  ),
                  Center(
                    child: SizedBox(
                      width: 150,
                      child: TextButton(
                          onPressed: () => showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: Text('確認'),
                                  content: Text('本当にこのレシピを削除しますか？'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Cancel'),
                                      child: Text('いいえ'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        if (recipe.recipeId != null) {
                                          bool deleteIsSuccess =
                                              await recipeDetailModel
                                                  .deleteRecipe(recipe);

                                          if (deleteIsSuccess) {
                                            Navigator.of(context).popUntil(
                                                (route) => route.isFirst);
                                            final snackBar = SnackBar(
                                                content: Text(
                                              '${recipe.recipeName}を削除しました',
                                              textAlign: TextAlign.center,
                                            ));
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          } else {
                                            final snackBar = SnackBar(
                                                content: const Text(
                                              'レシピの削除に失敗しました',
                                              textAlign: TextAlign.center,
                                            ));
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          }
                                        } else {
                                          print('else');
                                        }
                                      },
                                      child: Text('はい'),
                                    ),
                                  ],
                                ),
                              ),
                          child: Text(
                            'レシピを削除',
                          )),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
