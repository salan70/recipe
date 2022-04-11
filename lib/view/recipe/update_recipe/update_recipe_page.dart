import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

import 'package:recipe/auth/auth_controller.dart';
import 'package:recipe/components/widgets/edit_recipe_widget.dart';
import 'package:recipe/components/providers.dart';
import 'package:recipe/domain/recipe.dart';
import 'package:recipe/components/validation/validation.dart';
import 'package:recipe/view/recipe/update_recipe/update_recipe_model.dart';

class UpdateRecipePage extends ConsumerWidget {
  UpdateRecipePage(this.recipe);
  final Recipe recipe;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Validations validation = Validations();

    final user = ref.watch(authControllerProvider);

    final UpdateRecipeModel updateRecipeModel = UpdateRecipeModel(user: user!);

    final imageFile = ref.watch(imageFileNotifierProvider);

    final procedureList = ref.watch(procedureListNotifierProvider);
    final ingredientList = ref.watch(ingredientListNotifierProvider);

    final originalRecipe = recipe;

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
            'レシピを編集',
          ),
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () async {
                /// レシピ追加の条件を満たしている場合の処理
                if (validation.outputRecipeErrorText(recipe, ingredientList) ==
                    null) {
                  Recipe updatedRecipe = Recipe(
                      recipeName: recipe.recipeName,
                      recipeGrade: recipe.recipeGrade,
                      forHowManyPeople: recipe.forHowManyPeople,
                      recipeMemo: recipe.recipeMemo,
                      imageUrl: recipe.imageUrl,
                      imageFile: imageFile,
                      ingredientList: ingredientList,
                      procedureList: procedureList);

                  if (await updateRecipeModel.updateRecipe(
                      originalRecipe, updatedRecipe)) {
                    Navigator.pop(context);
                    final snackBar = SnackBar(
                        content: Text(
                      '${recipe.recipeName}を更新しました',
                      textAlign: TextAlign.center,
                    ));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    final snackBar = SnackBar(
                        content: const Text(
                      'レシピの更新に失敗しました',
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
