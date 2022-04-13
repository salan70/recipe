import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:recipe/components/providers.dart';

class RecipeDetailWidget extends ConsumerWidget {
  RecipeDetailWidget(this.recipeId, this.pageName);
  final String recipeId;
  final String pageName;

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
          return DefaultTextStyle(
            style: Theme.of(context).primaryTextTheme.bodyText1!,
            child: Container(
              margin: EdgeInsets.only(left: 16, right: 16),
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(height: 16),
                  Hero(
                    tag: 'recipeList recipeName' + recipe.recipeId! + pageName,
                    child: Container(
                      width: double.infinity,
                      color: Theme.of(context).backgroundColor,
                      child: Text(
                        recipe.recipeName!,
                        textAlign: TextAlign.left,
                        style: Theme.of(context).primaryTextTheme.headline5,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  // 画像
                  SizedBox(height: 8),
                  Container(
                    child: SizedBox(
                      height: 240,
                      width: double.infinity,
                      child: Hero(
                        tag: 'recipeList recipeImage' + recipeId + pageName,
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
                  ),
                  SizedBox(height: 8),
                  // 評価
                  Container(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Center(
                          child: RatingBar.builder(
                            ignoreGestures: true,
                            initialRating: recipe.recipeGrade!,
                            minRating: 0.5,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {},
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 材料
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    width: double.infinity,
                    child: Column(
                      children: [
                        DefaultTextStyle(
                          style: Theme.of(context).primaryTextTheme.subtitle2!,
                          child: Row(children: [
                            Text(
                              '材料',
                            ),
                            SizedBox(width: 4),
                            Text(
                              recipe.forHowManyPeople.toString(),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text('人分'),
                          ]),
                        ),
                        ingredientList.when(
                          error: (error, stack) => Text('Error: $error'),
                          loading: () => const CircularProgressIndicator(),
                          data: (ingredientList) {
                            if (ingredientList.isEmpty == false) {
                              WidgetsBinding.instance!
                                  .addPostFrameCallback((_) {
                                ingredientListNotifier.getList(ingredientList);
                              });
                            }
                            return ListView.builder(
                              itemCount: ingredientList.length,
                              itemBuilder: (context, index) {
                                var ingredient = ingredientList[index];
                                return Container(
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                          flex: 3,
                                          child:
                                              Text(ingredient.name.toString())),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                            '${ingredient.amount}${ingredient.unit}'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  // 手順
                  SizedBox(
                    height: 16,
                  ),
                  procedureList.when(
                      error: (error, stack) => Text('Error: $error'),
                      loading: () => const CircularProgressIndicator(),
                      data: (procedureList) {
                        if (procedureList.isEmpty == false) {
                          WidgetsBinding.instance!.addPostFrameCallback((_) {
                            procedureListNotifier.getList(procedureList);
                          });
                        }
                        return Container(
                          width: double.infinity,
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '手順',
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .subtitle2!,
                                ),
                              ),
                              ListView.builder(
                                itemCount: procedureList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var procedure = procedureList[index];
                                  return Container(
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                            flex: 1,
                                            child: Text('${index + 1}')),
                                        Expanded(
                                            flex: 19,
                                            child:
                                                Text('${procedure.content}')),
                                      ],
                                    ),
                                  );
                                },
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                              ),
                            ],
                          ),
                        );
                      }),
                  // メモ
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'メモ',
                            style:
                                Theme.of(context).primaryTextTheme.subtitle2!,
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 8,
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
                  ),
                ],
              ),
            ),
          );
        });
  }
}