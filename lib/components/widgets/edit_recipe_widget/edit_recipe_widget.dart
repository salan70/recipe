import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:image_picker/image_picker.dart';

import 'package:recipe/components/widgets/reordable_text_field/procedures.dart';
import 'package:recipe/components/widgets/reordable_text_field/ingredient_text_field/ingredient_text_field_widget.dart';
import 'package:recipe/components/providers.dart';
import 'package:recipe/domain/recipe.dart';
import 'package:recipe/view/other/edit_ingredient_unit/edit_ingredient_unit_page.dart';

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
          SizedBox(height: 16),
          TextField(
            maxLength: 30,
            style: Theme.of(context).primaryTextTheme.headline5,
            controller: TextEditingController(text: recipe.recipeName),
            decoration: InputDecoration.collapsed(hintText: 'レシピ名'),
            onChanged: (value) {
              recipe.recipeName = value;
            },
          ),
          // 画像
          SizedBox(height: 8),
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
                            color: Theme.of(context).dividerColor,
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
                            color: Theme.of(context).dividerColor,
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
          SizedBox(height: 8),
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
          SizedBox(height: 8),
          Column(
            children: [
              DefaultTextStyle(
                style: Theme.of(context).primaryTextTheme.subtitle2!,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text('材料'),
                          SizedBox(width: 8),
                          SizedBox(
                              width: 24,
                              child: TextField(
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                      left: 2, top: 4, bottom: 4),
                                  isDense: true,
                                ),
                                controller: recipe.forHowManyPeople == null
                                    ? null
                                    : TextEditingController(
                                        text:
                                            recipe.forHowManyPeople.toString()),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(2)
                                ],
                                onChanged: (value) {
                                  if (int.tryParse(value) != null) {
                                    recipe.forHowManyPeople = int.parse(value);
                                  }
                                },
                              )),
                          Text('人分'),
                        ],
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditIngredientUnitPage(),
                                  fullscreenDialog: false,
                                ));
                          },
                          child: Text('単位を編集')),
                    ]),
              ),
              SizedBox(height: 8),
              Container(
                child: IngredientTextFieldWidget(
                  recipe: recipe,
                ),
              ),
            ],
          ),

          // 手順
          SizedBox(height: 8),
          Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  '手順',
                  style: Theme.of(context).primaryTextTheme.subtitle2,
                ),
              ),
              SizedBox(height: 8),
              ProceduresListWidget(),
            ],
          ),
          // メモ
          SizedBox(height: 8),
          Container(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'メモ',
                    style: Theme.of(context).primaryTextTheme.subtitle2,
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: TextEditingController(text: recipe.recipeMemo),
                  maxLength: 500,
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
