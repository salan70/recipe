import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe/parts/reordable_text_field/procedures.dart';
import 'package:recipe/parts/reordable_text_field/ingredients.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe/providers.dart';
import 'package:recipe/view/recipe_list/recipe_list_screen.dart';
import 'package:recipe/domain/recipe.dart';
import 'package:recipe/view/add_recipe/add_redipe_model.dart';
import 'package:uuid/uuid.dart';

class AddRecipeScreen extends ConsumerWidget {
  final AddRecipeModel addRecipeModel = AddRecipeModel();

  // 材料テキストフィールド 初期値
  final ReorderableMultiTextFieldControllerIngredients controllerIngredients =
      ReorderableMultiTextFieldControllerIngredients([
    TextFieldStateIngredients(
      Uuid().v4(),
      TextEditingController(text: ''),
    )
  ]);

  final ReorderableMultiTextFieldController controllerProcedures =
      ReorderableMultiTextFieldController([]);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String? recipeName;
    String? recipeMemo;
    double? recipeGrade = 3.0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Center(
          child: TextField(
            decoration: InputDecoration.collapsed(hintText: "料理名"),
            onChanged: (value) {
              recipeName = value;
              // Providerから値を更新
              // recipeName.state = value;
            },
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
        width: double.infinity,
        child: ListView(
          children: [
            // 画像
            Container(
              height: 250,
              margin: EdgeInsets.only(top: 20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.grey[400],
              ),
              child: Icon(Icons.add_photo_alternate_outlined),
            ),
            // 評価
            Container(
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
                recipeGrade = rating;
              },
            )),
            // 材料 手作り
            // Container(
            //   color: Colors.grey,
            //   child: ListView(
            //     children: [],
            //   ),
            // ),

            // 材料 ネット引用
            Container(
              color: Colors.grey,
              child: Column(
                children: [
                  Container(
                    child: Text("材料"),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: ReorderableMultiTextFieldIngredients(
                      controller: controllerIngredients,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      controllerIngredients.add("");
                    },
                    child: Text("追加"),
                  )
                ],
              ),
            ),
            // 作り方
            // Container(
            //   color: Colors.blueGrey,
            //   child: Column(
            //     children: [
            //       Container(
            //         child: Text("作り方"),
            //       ),
            //       Container(
            //         padding: EdgeInsets.all(10),
            //         child: ReorderableMultiTextFieldProcedures(
            //           controller: controllerProcedures,
            //         ),
            //       ),
            //       TextButton(
            //         onPressed: () {
            //           controllerProcedures.add("");
            //         },
            //         child: Text("追加"),
            //       )
            //     ],
            //   ),
            // ),
            // メモ
            Container(
              color: Colors.grey,
              child: Column(
                children: [
                  Container(
                    child: Text("メモ"),
                  ),
                  TextField(
                    decoration:
                        InputDecoration.collapsed(hintText: "fill out here"),
                    maxLines: null,
                    onChanged: (value) {
                      recipeMemo = value;

                      // Providerから値を更新
                      // context.read(recipeMemoProvider).state = value;
                    },
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Recipe recipe = Recipe(recipeName, recipeGrade, recipeMemo);
                addRecipeModel.addRecipe(recipe);
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => RecipeListPage(),
                //       fullscreenDialog: true,
                //     ));
              },
              child: Text("追加"),
            ),
          ],
        ),
      ),
    );
  }
}
