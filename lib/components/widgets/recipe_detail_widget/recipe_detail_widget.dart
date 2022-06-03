import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:recipe/state/other_provider/providers.dart';
import 'package:recipe/state/ingredient_list/ingredient_list_provider.dart';
import 'package:recipe/state/procedure_list/procedure_list_provider.dart';

class RecipeDetailWidget extends ConsumerWidget {
  RecipeDetailWidget(this.recipeId);
  final String recipeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipe = ref.watch(recipeStreamProviderFamily(recipeId));

    final ingredientListNotifier =
        ref.watch(ingredientListNotifierProvider.notifier);

    final procedureListNotifier =
        ref.watch(procedureListNotifierProvider.notifier);

    return recipe.when(
        error: (error, stack) => Text('Error: $error'),
        loading: () => const CircularProgressIndicator(),
        data: (recipe) {
          if (recipe.ingredientList != null) {
            if (recipe.ingredientList!.isEmpty == false) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ingredientListNotifier.getList(recipe.ingredientList!);
              });
            }
          }
          if (recipe.ingredientList != null) {
            if (recipe.procedureList!.isEmpty == false) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                procedureListNotifier.getList(recipe.procedureList!);
              });
            }
          }
          return DefaultTextStyle(
            style: Theme.of(context).primaryTextTheme.bodyText1!,
            child: Container(
              margin: EdgeInsets.only(left: 16, right: 16).r,
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(height: 16.h),
                  Container(
                    width: double.infinity,
                    child: Text(
                      recipe.recipeName!,
                      textAlign: TextAlign.left,
                      style: Theme.of(context).primaryTextTheme.headline5,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // 画像
                  SizedBox(height: 8.h),
                  Container(
                    child: SizedBox(
                      height: 240.h,
                      width: double.infinity,
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
                                color: Theme.of(context).dividerColor,
                              ),
                              child: Icon(Icons.restaurant_outlined),
                            ),
                    ),
                  ),
                  SizedBox(height: 8.h),
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
                            itemPadding:
                                EdgeInsets.symmetric(horizontal: 4.0).r,
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
                    height: 16.h,
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
                            SizedBox(width: 4.w),
                            Text(
                              recipe.forHowManyPeople.toString(),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text('人分'),
                          ]),
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        ListView.builder(
                          itemCount: recipe.ingredientList == null
                              ? 0
                              : recipe.ingredientList!.length,
                          itemBuilder: (context, index) {
                            var ingredient = recipe.ingredientList == null
                                ? null
                                : recipe.ingredientList![index];
                            return Column(
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                          flex: 3,
                                          child: Text(
                                              ingredient!.name.toString())),
                                      SizedBox(
                                        width: 8.w,
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                            '${ingredient.amount}${ingredient.unit}'),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(),
                              ],
                            );
                          },
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                        ),
                        // },
                        // ),
                      ],
                    ),
                  ),

                  // 手順
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
                            '手順',
                            style:
                                Theme.of(context).primaryTextTheme.subtitle2!,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        ListView.builder(
                          itemCount: recipe.procedureList == null
                              ? 0
                              : recipe.procedureList!.length,
                          itemBuilder: (BuildContext context, int index) {
                            var procedure = recipe.procedureList == null
                                ? null
                                : recipe.procedureList![index];
                            return Column(
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                          flex: 1, child: Text('${index + 1}')),
                                      Expanded(
                                          flex: 19,
                                          child: Text('${procedure!.content}')),
                                    ],
                                  ),
                                ),
                                Divider(),
                              ],
                            );
                          },
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                        ),
                      ],
                    ),
                  ),
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
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 8,
                            ),
                            Flexible(
                              child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: recipe.recipeMemo != null
                                      ? Text(
                                          recipe.recipeMemo!,
                                        )
                                      : Text('')),
                            ),
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
