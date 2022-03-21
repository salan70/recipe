import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:recipe/domain/cart.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

import 'package:recipe/providers.dart';
import 'package:recipe/auth/auth_controller.dart';
import 'package:recipe/view/add_cart_recipe_detail/add_cart_recipe_detail_page.dart';
import 'package:recipe/view/recipe_list/recipe_list_model.dart';
import 'package:recipe/domain/recipe.dart';

// レシピ一覧画面
class AddCartRecipeListPage extends ConsumerWidget {
  AddCartRecipeListPage({Key? key}) : super(key: key);

  final ScrollController listViewController = new ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipes = ref.watch(recipeListStreamProvider);
    final inCartRecipes = ref.watch(inCartRecipeListStreamProvider);
    RecipeListModel recipeListModel = RecipeListModel();
    List<InCartRecipe>? inCartRecipeList;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.green,
        ),
        elevation: 1,
        title: Text('かごに追加するレシピを選択'),
      ),
      body: SnappingSheet(
        child: recipes.when(
            error: (error, stack) => Text('Error: $error'),
            loading: () => const CircularProgressIndicator(),
            data: (recipes) {
              return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = recipes[index];
                    final ingredients = ref.watch(
                        ingredientListStreamProviderFamily(recipe.recipeId!));
                    String outputIngredientText = '';

                    final procedures = ref.watch(
                        procedureListStreamProviderFamily(recipe.recipeId!));

                    ingredients.when(
                        data: (ingredient) {
                          recipe.ingredientList = ingredient;

                          outputIngredientText = recipeListModel
                              .toOutputIngredientText(ingredient);
                        },
                        error: (error, stack) => Text('Error: $error'),
                        loading: () => const CircularProgressIndicator());

                    procedures.when(
                        data: (procedure) {
                          recipe.procedureList = procedure;
                        },
                        error: (error, stack) => Text('Error: $error'),
                        loading: () => const CircularProgressIndicator());

                    return GestureDetector(
                      ///画面遷移
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              fullscreenDialog: true,
                              builder: (context) =>
                                  AddBasketRecipeDetailPage(recipe.recipeId!),
                            ));
                      },

                      child: Card(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Expanded(
                              flex: 1,
                              child: Hero(
                                tag: 'recipeName' + recipe.recipeId!,
                                child: Text(
                                  recipe.recipeName.toString(),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: SizedBox(
                                  width: 200,
                                  height: 120,
                                  child: Hero(
                                    tag: 'recipeImage' + recipe.recipeId!,
                                    child: recipe.imageUrl != null
                                        ? recipe.imageUrl != ''
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
                                                      BorderRadius.circular(
                                                          8.0),
                                                  color: Colors.grey[400],
                                                ),
                                                child: Icon(Icons
                                                    .add_photo_alternate_outlined),
                                              )
                                        : CircularProgressIndicator(),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                outputIngredientText,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            }),

        ///snapingsheet
        lockOverflowDrag: true,
        snappingPositions: [
          SnappingPosition.factor(
            positionFactor: 0.0,
            snappingCurve: Curves.easeOutExpo,
            snappingDuration: Duration(seconds: 1),
            grabbingContentOffset: GrabbingContentOffset.top,
          ),
          SnappingPosition.factor(
            snappingCurve: Curves.elasticOut,
            snappingDuration: Duration(milliseconds: 1750),
            positionFactor: 0.5,
          ),
          SnappingPosition.factor(
            grabbingContentOffset: GrabbingContentOffset.bottom,
            snappingCurve: Curves.easeInExpo,
            snappingDuration: Duration(seconds: 1),
            positionFactor: 0.9,
          ),
        ],
        grabbingHeight: 24,
        sheetAbove: null,
        grabbing: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(blurRadius: 25, color: Colors.black.withOpacity(0.2)),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(top: 9),
                width: 100,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              Container(
                color: Colors.grey[200],
                height: 2,
                margin: EdgeInsets.all(15).copyWith(top: 0, bottom: 0),
              )
            ],
          ),
        ),
        sheetBelow: SnappingSheetContent(
          draggable: true,
          childScrollController: listViewController,
          child: inCartRecipes.when(
              error: (error, stack) => Text('Error: $error'),
              loading: () => const CircularProgressIndicator(),
              data: (inCartRecipes) {
                inCartRecipeList = inCartRecipes;
                return Container(
                  color: Colors.white,
                  child: ListView.builder(
                      controller: listViewController,
                      itemCount: inCartRecipes.length,
                      itemBuilder: (context, index) {
                        final inCartRecipe = inCartRecipes[index];
                        final recipe = ref.watch(
                            inCartRecipeStreamProviderFamily(
                                inCartRecipe.recipeId!));

                        return recipe.when(
                            error: (error, stack) => Text('Error: $error'),
                            loading: () => const CircularProgressIndicator(),
                            data: (recipe) {
                              final counter = ref.watch(
                                  recipeNumCountProviderFamily(
                                      inCartRecipe.count));
                              final counterNotifier = ref.watch(
                                  recipeNumCountProviderFamily(
                                          inCartRecipe.count)
                                      .notifier);

                              // inCartRecipeList![index].recipeName =
                              //     recipe.recipeName;
                              // inCartRecipeList![index].count = counter;

                              return Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      recipe.recipeName.toString(),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      child: Text(
                                          '合計${recipe.forHowManyPeople! * counter}人分'),
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              if (counter > 1) {
                                                counterNotifier.state--;
                                              }
                                            },
                                            icon: counter == 1
                                                ? Icon(
                                                    Icons.remove_circle_outline)
                                                : Icon(Icons.remove_circle)),
                                        Text('× $counter'),
                                        IconButton(
                                            onPressed: () {
                                              counterNotifier.state++;
                                            },
                                            icon: Icon(Icons.add_circle)),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            });
                      }),
                );
              }),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 64.0,
          child: Row(
            children: [
              Expanded(
                  child: Container(child: Icon(Icons.shopping_cart_outlined))),
              Expanded(child: Container()),
              Expanded(
                  child: Container(
                child: ElevatedButton(
                  onPressed: () {
                    if (inCartRecipeList != null) {
                      for (var inCartRecipe in inCartRecipeList!) {
                        print(
                            '${inCartRecipe.recipeName} ${inCartRecipe.count}');
                      }
                    }
                  },
                  child: Text('確定'),
                ),
              ))
            ],
          ),
        ),
        shape: CircularNotchedRectangle(),
      ),
    );
  }
}
