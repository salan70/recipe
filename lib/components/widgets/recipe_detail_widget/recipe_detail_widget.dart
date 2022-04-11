import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:recipe/components/providers.dart';

class RecipeDetailWidget extends ConsumerWidget {
  RecipeDetailWidget(this.recipeId);
  final String recipeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipe = ref.watch(recipeStreamProviderFamily(recipeId));

    final ingredientList =
        ref.watch(ingredientListStreamProviderFamily(recipeId));
    final ingredientListNotifier =
        ref.watch(ingredientListNotifierProvider.notifier);

    final procedureList =
        ref.watch(procedureListStreamProviderFamily(recipeId));
    final procedureListNotifier =
        ref.watch(procedureListNotifierProvider.notifier);

    return recipe.when(
        error: (error, stack) => Text('Error: $error'),
        loading: () => const CircularProgressIndicator(),
        data: (recipe) {
          return Container(
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(height: 8),
                Hero(
                  tag: 'recipeList recipeName' + recipe.recipeId!,
                  child: Container(
                    width: double.infinity,
                    child: Text(
                      recipe.recipeName!,
                      textAlign: TextAlign.left,
                      style: Theme.of(context).primaryTextTheme.subtitle1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                // 画像
                SizedBox(
                  height: 250,
                  width: double.infinity,
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
                                  Text(procedureList[index].content.toString()),
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
              ],
            ),
          );
        });
  }
}
