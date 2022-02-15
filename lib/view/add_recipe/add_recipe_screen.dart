import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:recipe/auth/auth_controller.dart';
import 'package:recipe/parts/reordable_text_field/procedures.dart';
import 'package:recipe/parts/reordable_text_field/ingredients.dart';
import 'package:recipe/providers.dart';
import 'package:recipe/view/recipe_list/recipe_list_screen.dart';
import 'package:recipe/domain/recipe.dart';
import 'package:recipe/view/add_recipe/add_redipe_model.dart';
import 'package:recipe/parts/validation/validation.dart';

class AddRecipeScreen extends ConsumerWidget {
  final AddRecipeModel addRecipeModel = AddRecipeModel("", "", 3.0, "", null);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Validation validation = Validation();

    final authControllerState = ref.watch(authControllerProvider);

    final imageFile = ref.watch(imageFileNotifierProvider);
    final imageFileNotifier = ref.watch(imageFileNotifierProvider.notifier);

    final proceduresList = ref.watch(procedureListNotifierProvider);
    final ingredientList = ref.watch(ingredientListNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.blue,
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Center(
          child: TextField(
            decoration: InputDecoration.collapsed(hintText: "料理名"),
            onChanged: (value) {
              addRecipeModel.recipeName = value;
              // Providerから値を更新
              // recipeName.state = value;
            },
          ),
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () async {
                if (authControllerState != null) {
                  String uid = authControllerState.uid;
                  print("uid:" + authControllerState.uid);

                  bool isOk = true;
                  for (int index = 0; index < ingredientList.length; index++) {
                    if (validation.errorText(ingredientList[index].amount) !=
                        null) {
                      // 材料の数量の再入力を求める

                      print("false");
                      isOk = false;
                    }
                  }

                  if (isOk) {
                    print("===追加===");
                    Recipe recipe = Recipe(
                        addRecipeModel.recipeName,
                        addRecipeModel.recipeGrade,
                        addRecipeModel.recipeMemo,
                        imageFile.imageFile);
                    addRecipeModel.addRecipe(
                        uid, recipe, ingredientList, proceduresList);

                    Navigator.pop(context);
                  }
                }
              },
              icon: Icon(Icons.check))
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
        width: double.infinity,
        child: ListView(
          children: [
            SizedBox(height: 20),
            // 画像
            GestureDetector(
              child: SizedBox(
                height: 250,
                child: imageFile.imageFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.file(imageFile.imageFile!))
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.grey[400],
                        ),
                        child: Icon(Icons.add_photo_alternate_outlined),
                      ),
              ),
              onTap: () async {
                await imageFileNotifier.pickImage();
              },
            ),
            // 評価
            Center(
                child: RatingBar.builder(
              initialRating: 3,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                addRecipeModel.recipeGrade = rating;
              },
            )),

            // 材料
            Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text("材料"),
                ),
                Container(
                  child: IngredientListWidget(),
                ),
              ],
            ),

            // 手順
            Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text("手順"),
                ),
                ProceduresListWidget(),
              ],
            ),
            // メモ
            Container(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text("メモ"),
                  ),
                  TextField(
                    maxLines: null,
                    onChanged: (value) {
                      addRecipeModel.recipeMemo = value;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
