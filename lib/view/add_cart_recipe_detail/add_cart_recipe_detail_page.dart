import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:recipe/components/providers.dart';
import 'package:recipe/domain/recipe.dart';
import 'package:recipe/repository/cart_repository.dart';
import 'package:recipe/repository/recipe_repository.dart';
import 'package:recipe/view/add_cart_recipe_detail/add_cart_recipe_detail_model.dart';
import 'package:recipe/view/update_recipe/update_recipe_page.dart';

class AddBasketRecipeDetailPage extends ConsumerWidget {
  AddBasketRecipeDetailPage(this.recipeId);
  final String recipeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider);
    CartRepository cartRepository = CartRepository(user: user!);
    AddCartRecipeDetailModel addCartRecipeDetailModel =
        AddCartRecipeDetailModel(user: user);

    final recipe = ref.watch(recipeStreamProviderFamily(recipeId));

    final ingredientList =
        ref.watch(ingredientListStreamProviderFamily(recipeId));

    final procedureList =
        ref.watch(procedureListStreamProviderFamily(recipeId));

    final ingredientListNotifier =
        ref.watch(ingredientListNotifierProvider.notifier);
    final procedureListNotifier =
        ref.watch(procedureListNotifierProvider.notifier);

    var counter = ref.watch(recipeNumCountProviderFamily(null));
    var counterNotifier =
        ref.watch(recipeNumCountProviderFamily(null).notifier);

    bool isExistInCart = false;
    String? inCartRecipeId;
    final inCartRecipes = ref.watch(inCartRecipeListStreamProvider);

    if (cartRepository.searchRecipe(recipeId)) {
      isExistInCart = true;
    }

    int fowHowManyPeople = 0;

    return Scaffold(
      appBar: recipe.when(
          error: (error, stack) => AppBar(),
          loading: () => AppBar(
                elevation: 1,
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
              title: Center(
                child: Hero(
                  tag: 'recipeName' + recipe.recipeId!,
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: recipe.when(
                  error: (error, stack) => Text('Error: $error'),
                  loading: () => const CircularProgressIndicator(),
                  data: (recipe) {
                    fowHowManyPeople = recipe.forHowManyPeople!;
                    return Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 20.0, right: 20.0),
                          width: double.infinity,
                          child: ListView(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            children: [
                              SizedBox(height: 20),
                              // 画像
                              SizedBox(
                                height: 250,
                                child: Hero(
                                  tag: 'recipeImage' + recipe.recipeId!,
                                  child: recipe.imageUrl != ''
                                      ? Image.network(
                                          recipe.imageUrl!,
                                          errorBuilder: (c, o, s) {
                                            return const Icon(
                                              Icons.error,
                                              color: Colors.red,
                                            );
                                          },
                                        )
                                      : Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            color: Colors.grey[400],
                                          ),
                                          child: Icon(Icons
                                              .add_photo_alternate_outlined),
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
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 4.0),
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
                                    error: (error, stack) =>
                                        Text('Error: $error'),
                                    loading: () =>
                                        const CircularProgressIndicator(),
                                    data: (ingredientList) {
                                      if (ingredientList.isEmpty == false) {
                                        WidgetsBinding.instance!
                                            .addPostFrameCallback((_) {
                                          ingredientListNotifier
                                              .getList(ingredientList);
                                        });
                                      }
                                      return ListView.builder(
                                        itemCount: ingredientList.length,
                                        itemBuilder: (context, index) {
                                          return Row(
                                            children: [
                                              Text(ingredientList[index]
                                                  .name
                                                  .toString()),
                                              Text(ingredientList[index]
                                                  .amount
                                                  .toString()),
                                              Text(ingredientList[index]
                                                  .unit
                                                  .toString()),
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
                                  error: (error, stack) =>
                                      Text('Error: $error'),
                                  loading: () =>
                                      const CircularProgressIndicator(),
                                  data: (procedureList) {
                                    if (procedureList.isEmpty == false) {
                                      WidgetsBinding.instance!
                                          .addPostFrameCallback((_) {
                                        procedureListNotifier
                                            .getList(procedureList);
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
                                          itemBuilder: (BuildContext context,
                                              int index) {
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
                                          physics:
                                              NeverScrollableScrollPhysics(),
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
                        ),
                      ],
                    );
                  }),
            ),
          ),
          Column(
            children: [
              isExistInCart == false
                  ? _counterWidget(fowHowManyPeople, counter, counterNotifier)
                  : inCartRecipes.when(
                      error: (error, stack) => Text('Error: $error'),
                      loading: () => const CircularProgressIndicator(),
                      data: (inCartRecipes) {
                        for (var inCartRecipe in inCartRecipes) {
                          if (inCartRecipe.recipeId == recipeId) {
                            counter = ref.watch(recipeNumCountProviderFamily(
                                inCartRecipe.count));
                            counterNotifier = ref.watch(
                                recipeNumCountProviderFamily(inCartRecipe.count)
                                    .notifier);
                            inCartRecipeId = inCartRecipe.inCartRecipeId;
                            break;
                          }
                        }
                        return _counterWidget(
                            fowHowManyPeople, counter, counterNotifier);
                      }),
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
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: Text('いいえ'),
                            ),
                            TextButton(
                              onPressed: () async {
                                print('はい');
                                await addCartRecipeDetailModel
                                    .addOrUpdateRecipe(
                                        inCartRecipeId, recipeId, counter);
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
                      await addCartRecipeDetailModel.addOrUpdateRecipe(
                          inCartRecipeId, recipeId, counter);
                      Navigator.pop(context);
                    }
                  },
                  child: Text('確定'),
                ),
              ),
            ],
          ),
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
