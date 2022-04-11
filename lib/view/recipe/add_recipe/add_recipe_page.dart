import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

import 'package:recipe/auth/auth_controller.dart';
import 'package:recipe/components/widgets/edit_recipe_widget.dart';
import 'package:recipe/components/providers.dart';
import 'package:recipe/domain/recipe.dart';
import 'package:recipe/components/validation/validation.dart';

import 'add_recipe_model.dart';

class AddRecipePage extends ConsumerWidget {
  final Recipe recipe = Recipe(recipeGrade: 3);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Validations validation = Validations();

    final user = ref.watch(authControllerProvider);

    final AddRecipeModel addRecipeModel = AddRecipeModel(user: user!);

    final imageFile = ref.watch(imageFileNotifierProvider);

    final procedureList = ref.watch(procedureListNotifierProvider);
    final ingredientList = ref.watch(ingredientListNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Center(
          child: Text(
            'レシピを追加',
          ),
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () async {
                /// レシピ追加の条件を満たしている場合の処理
                if (validation.outputRecipeErrorText(recipe, ingredientList) ==
                    null) {
                  Recipe addedRecipe = Recipe(
                      recipeName: recipe.recipeName,
                      recipeGrade: recipe.recipeGrade,
                      forHowManyPeople: recipe.forHowManyPeople,
                      recipeMemo: recipe.recipeMemo,
                      imageUrl: '',
                      imageFile: imageFile,
                      ingredientList: ingredientList,
                      procedureList: procedureList);

                  if (await addRecipeModel.addRecipe(addedRecipe)) {
                    Navigator.pop(context);
                    final snackBar = SnackBar(
                        content: Text(
                      '${recipe.recipeName}を追加しました',
                      textAlign: TextAlign.center,
                    ));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    final snackBar = SnackBar(
                        content: const Text(
                      'レシピの追加に失敗しました',
                      textAlign: TextAlign.center,
                    ));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                }

                /// レシピ追加の条件を満たしていない場合の処理
                else {
                  final recipeErrorText =
                      validation.outputRecipeErrorText(recipe, ingredientList);
                  final snackBar = SnackBar(
                    content: Text(
                      recipeErrorText!,
                      textAlign: TextAlign.center,
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              icon: Icon(Icons.check))
        ],
      ),
      body: EditRecipeWidget(recipe),
    );
  }
}
