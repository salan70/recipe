import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../state/ingredient_list/ingredient_list_provider.dart';
import '../../../state/other_provider/providers.dart';
import '../../../state/procedure_list/procedure_list_provider.dart';

class RecipeDetailWidget extends ConsumerWidget {
  const RecipeDetailWidget({Key? key, required this.recipeId})
      : super(key: key);
  final String recipeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipe = ref.watch(recipeProviderFamily(recipeId));

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
          style: Theme.of(context).textTheme.subtitle1!,
          child: Container(
            margin: const EdgeInsets.only(left: 16, right: 16).r,
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(height: 16.h),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    recipe.recipeName!,
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.headline5,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // 画像
                SizedBox(height: 8.h),
                SizedBox(
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
                      : DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Theme.of(context).dividerColor,
                          ),
                          child: const Icon(Icons.restaurant_outlined),
                        ),
                ),
                SizedBox(height: 8.h),
                // 評価
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Center(
                        child: RatingBar.builder(
                          ignoreGestures: true,
                          initialRating: recipe.recipeGrade!,
                          minRating: 0.5,
                          allowHalfRating: true,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 4).r,
                          itemBuilder: (context, _) => const Icon(
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
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      DefaultTextStyle(
                        style: Theme.of(context).textTheme.subtitle2!,
                        child: Row(
                          children: [
                            const Text(
                              '材料',
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              recipe.forHowManyPeople.toString(),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Text('人分'),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      ListView.builder(
                        itemCount: recipe.ingredientList == null
                            ? 0
                            : recipe.ingredientList!.length,
                        itemBuilder: (context, index) {
                          final ingredient = recipe.ingredientList == null
                              ? null
                              : recipe.ingredientList![index];
                          return Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 24.w,
                                    child: (ingredient!.symbol == 'clover' ||
                                            ingredient.symbol == 'a')
                                        ? Text(
                                            'a',
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          )
                                        : (ingredient.symbol == 'diamond' ||
                                                ingredient.symbol == 'b')
                                            ? Text(
                                                'b',
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                ),
                                              )
                                            : null,
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(ingredient.name.toString()),
                                  ),
                                  SizedBox(
                                    width: 8.w,
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      '${ingredient.amount}${ingredient.unit}',
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(),
                            ],
                          );
                        },
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                      ),
                      // },
                      // ),
                    ],
                  ),
                ),

                // 手順
                SizedBox(
                  height: 16.h,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '手順',
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      ListView.builder(
                        itemCount: recipe.procedureList == null
                            ? 0
                            : recipe.procedureList!.length,
                        itemBuilder: (BuildContext context, int index) {
                          final procedure = recipe.procedureList == null
                              ? null
                              : recipe.procedureList![index];
                          return Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 8.w,
                                  ),
                                  Expanded(child: Text('${index + 1}')),
                                  Expanded(
                                    flex: 19,
                                    child: Text('${procedure!.content}'),
                                  ),
                                ],
                              ),
                              const Divider(),
                            ],
                          );
                        },
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                      ),
                    ],
                  ),
                ),
                // メモ
                SizedBox(
                  height: 16.h,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'メモ',
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 8.w,
                          ),
                          Flexible(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: recipe.recipeMemo != null
                                  ? Text(
                                      recipe.recipeMemo!,
                                    )
                                  : const Text(''),
                            ),
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
      },
    );
  }
}
