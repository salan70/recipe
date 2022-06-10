import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:recipe/state/other_provider/providers.dart';
import 'package:recipe/components/widgets/recipe_detail_widget/recipe_detail_widget.dart';
import 'package:recipe/state/auth/auth_provider.dart';
import 'package:recipe/view/recipe/update_recipe/update_recipe_page.dart';

import 'add_cart_recipe_detail_model.dart';

class AddBasketRecipeDetailPage extends ConsumerWidget {
  AddBasketRecipeDetailPage(this.recipeId, this.fromPageName);
  final String recipeId;
  final String fromPageName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userStateNotifierProvider);
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
              elevation: 1,
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
                      Navigator.push<MaterialPageRoute>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateRecipePage(recipe),
                            fullscreenDialog: true,
                          ));
                    },
                    icon: const Icon(Icons.edit))
              ],
            );
          }),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: recipe.when(
                    error: (error, stack) => Text('Error: $error'),
                    loading: () => const CircularProgressIndicator(),
                    data: (recipe) {
                      return RecipeDetailWidget(recipeId);
                    }),
              ),
            ),
            recipe.when(
                error: (error, stack) => Text('Error: $error'),
                loading: () => const CircularProgressIndicator(),
                data: (recipe) {
                  final counter = ref
                      .watch(recipeNumCountProviderFamily(recipe.countInCart));
                  final counterNotifier = ref.watch(
                      recipeNumCountProviderFamily(recipe.countInCart)
                          .notifier);
                  return Container(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 48)
                            .r,
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(
                      color: Theme.of(context).dividerColor,
                    ))),
                    child: Column(
                      children: [
                        _counterWidget(context, recipe.forHowManyPeople!,
                            counter, counterNotifier),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: EdgeInsets.only(right: 14).r,
                            child: SizedBox(
                              width: 144.w,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (counter == 0) {
                                    showDialog<AlertDialog>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('確認'),
                                        content: Text('数量が0ですがよろしいですか？'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                context, 'Cancel'),
                                            child: Text('いいえ'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              EasyLoading.show(
                                                  status: 'loading...');
                                              final errorText =
                                                  await addCartRecipeDetailModel
                                                      .updateCount(
                                                          recipeId, counter);
                                              if (errorText == null) {
                                                int popInt = 0;
                                                Navigator.popUntil(context,
                                                    (_) => popInt++ >= 2);

                                                EasyLoading.showSuccess(
                                                    'カートを更新しました');
                                              } else {
                                                EasyLoading.dismiss();
                                                showDialog<AlertDialog>(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title:
                                                          const Text('カート更新失敗'),
                                                      content:
                                                          Text('$errorText'),
                                                      actions: [
                                                        TextButton(
                                                          child:
                                                              const Text('閉じる'),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                            child: const Text('はい'),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    EasyLoading.show(status: 'loading...');
                                    final errorText =
                                        await addCartRecipeDetailModel
                                            .updateCount(recipeId, counter);

                                    if (errorText == null) {
                                      Navigator.pop(context);

                                      EasyLoading.showSuccess(
                                          '${recipe.recipeName}をカートに追加しました');
                                    } else {
                                      EasyLoading.dismiss();
                                      showDialog<AlertDialog>(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text('カート更新失敗'),
                                            content: Text('$errorText'),
                                            actions: [
                                              TextButton(
                                                child: Text('閉じる'),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  }
                                },
                                child: Text(
                                  '確定',
                                  style: TextStyle(fontSize: 20.sp),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }

  Widget _counterWidget(BuildContext context, int fowHowManyPeople, int counter,
      StateController<int> counterNotifier) {
    return SizedBox(
        height: 40.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '計${fowHowManyPeople * counter}人分',
              style: Theme.of(context).primaryTextTheme.headline6,
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      if (counter > 0) {
                        counterNotifier.state--;
                      }
                    },
                    icon: counter == 0
                        ? const Icon(Icons.remove_circle_outline)
                        : const Icon(Icons.remove_circle)),
                Text(
                  '× $counter',
                  style: Theme.of(context).primaryTextTheme.headline6,
                ),
                IconButton(
                  onPressed: () {
                    if (counter < 99) {
                      counterNotifier.state++;
                    }
                  },
                  icon: counter == 99
                      ? const Icon(Icons.add_circle_outline)
                      : const Icon(Icons.add_circle),
                )
              ],
            ),
          ],
        ));
  }
}
