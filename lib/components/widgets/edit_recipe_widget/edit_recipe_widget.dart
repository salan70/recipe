import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:image_picker/image_picker.dart';

import 'package:recipe/auth/auth_controller.dart';
import 'package:recipe/components/widgets/reordable_text_field/procedures.dart';
import 'package:recipe/components/widgets/reordable_text_field/ingredient_text_field/ingredient_text_field_widget.dart';
import 'package:recipe/components/providers.dart';
import 'package:recipe/domain/recipe.dart';
import 'package:recipe/view/other/ingredient_unit_edit/ingredient_unit_edit_page.dart';

class EditRecipeWidget extends ConsumerWidget {
  EditRecipeWidget(this.recipe);
  final Recipe recipe;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageFile = ref.watch(imageFileNotifierProvider);
    final imageFileNotifier = ref.watch(imageFileNotifierProvider.notifier);

    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 20.0),
      width: double.infinity,
      child: ListView(
        children: [
          SizedBox(height: 20),
          TextField(
            controller: TextEditingController(text: recipe.recipeName),
            decoration: InputDecoration.collapsed(hintText: "レシピ名"),
            onChanged: (value) {
              recipe.recipeName = value;
            },
          ),
          // 画像
          GestureDetector(
            child: SizedBox(
              height: 250,
              child: imageFile != null
                  ? imageFile.path != ''
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(imageFile))
                      : Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.grey[400],
                          ),
                          child: Icon(Icons.add_photo_alternate_outlined),
                        )
                  : recipe.imageUrl != '' && recipe.imageUrl != null
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
                            color: Colors.blue[400],
                          ),
                          child: Icon(Icons.add_photo_alternate_outlined),
                        ),
            ),
            onTap: () {
              showAdaptiveActionSheet(
                context: context,
                title: const Text('画像の選択'),
                androidBorderRadius: 30,
                actions: <BottomSheetAction>[
                  BottomSheetAction(
                      title: const Text('アルバムから選択'),
                      onPressed: () async {
                        await imageFileNotifier.pickImage(ImageSource.gallery);
                        Navigator.pop(context);
                      }),
                  BottomSheetAction(
                      title: const Text('カメラで撮影'),
                      onPressed: () async {
                        await imageFileNotifier.pickImage(ImageSource.camera);
                        Navigator.pop(context);
                      }),
                ],
                cancelAction: CancelAction(
                    title: const Text('キャンセル'),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              );
            },
          ),
          // 評価
          Center(
              child: RatingBar.builder(
            initialRating: recipe.recipeGrade!,
            minRating: 0.5,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star_rounded,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              recipe.recipeGrade = rating;
            },
          )),

          // 材料
          Column(
            children: [
              Row(children: [
                Text("材料"),
                SizedBox(width: 10),
                SizedBox(
                    width: 32,
                    child: TextField(
                      controller: recipe.forHowManyPeople == null
                          ? null
                          : TextEditingController(
                              text: recipe.forHowManyPeople.toString()),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      onChanged: (value) {
                        if (int.tryParse(value) != null) {
                          recipe.forHowManyPeople = int.parse(value);
                        }
                      },
                    )),
                Text("人分"),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => IngredientUnitEditPage(),
                            fullscreenDialog: false,
                          ));
                    },
                    child: Text('単位を編集')),
              ]),
              Container(
                child: IngredientTextFieldWidget(
                  recipe: recipe,
                ),
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
                  controller: TextEditingController(text: recipe.recipeMemo),
                  maxLines: null,
                  onChanged: (value) {
                    recipe.recipeMemo = value;
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
