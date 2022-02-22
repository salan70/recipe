import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:recipe/providers.dart';

import 'package:recipe/auth/auth_controller.dart';
import 'package:recipe/view/add_recipe/add_recipe_screen.dart';
import 'package:recipe/view/recipe_list/recipe_list_model.dart';
import 'package:recipe/domain/recipe.dart';

// レシピ一覧画面
class RecipeListPage extends ConsumerWidget {
  const RecipeListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String? recipeId;

    final recipes = ref.watch(recipesStreamProvider);
    RecipeListModel recipeListModel = RecipeListModel();

    final authControllerState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'レシピ一覧',
          style: TextStyle(
            color: Colors.green,
          ),
        ),
      ),
      body: recipes.when(
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
                  recipeId = recipes[index].recipeId!;
                  // print(recipeId);
                  final ingredients =
                      ref.watch(ingredientsStreamProviderFamily(recipeId!));
                  return Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          recipe.recipeName.toString(),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: SizedBox(
                              width: 200,
                              height: 120,
                              child: recipe.imageUrl != ""
                                  ? Image.network(recipe.imageUrl.toString())
                                  : Container(
                                      color: Colors.blueGrey,
                                    )),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: ingredients.when(
                            error: (error, stack) => Text('Error: $error'),
                            loading: () => const CircularProgressIndicator(),
                            data: (ingredients) {
                              String outputIngredientText = recipeListModel
                                  .toOutputIngredientText(ingredients);
                              return Text(
                                outputIngredientText,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              );
                            }),
                      ),
                    ],
                  );
                });
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Icon(
          Icons.add,
          color: Colors.green,
          size: 30.0,
        ),
        elevation: 3.0,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddRecipeScreen(),
                fullscreenDialog: true,
              ));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Container(height: 50.0),
        shape: CircularNotchedRectangle(),
      ),
    );
  }
}
