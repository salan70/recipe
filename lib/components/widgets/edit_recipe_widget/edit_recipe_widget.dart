import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:recipe/components/widgets/reordable_text_field/ingredient_text_field/ingredient_text_field_widget.dart';
import 'package:recipe/components/widgets/reordable_text_field/procedure_text_field/procedure_text_field_widget.dart';
import 'package:recipe/domain/recipe.dart';
import 'package:recipe/state/image_file/image_file_provider.dart';
import 'package:recipe/view/other/introduction_edit_ingredient/introduction_edit_ingredient_page.dart';

class EditRecipeWidget extends ConsumerWidget {
  const EditRecipeWidget({Key? key, required this.recipe}) : super(key: key);
  final Recipe recipe;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageFile = ref.watch(imageFileNotifierProvider);
    final imageFileNotifier = ref.watch(imageFileNotifierProvider.notifier);

    return GestureDetector(
      onTap: () {
        final currentScope = FocusScope.of(context);
        if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: Container(
        margin: const EdgeInsets.only(left: 20, right: 20).r,
        width: double.infinity,
        child: ListView(
          children: [
            SizedBox(height: 16.h),
            TextField(
              maxLength: 30,
              maxLines: 2,
              style: Theme.of(context).textTheme.headline5,
              controller: TextEditingController(text: recipe.recipeName),
              decoration: const InputDecoration.collapsed(hintText: 'レシピ名'),
              onChanged: (value) {
                recipe.recipeName = value;
              },
            ),
            // 画像
            SizedBox(height: 8.h),
            GestureDetector(
              child: SizedBox(
                height: 250.h,
                child: imageFile != null
                    ? imageFile.path != ''
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.file(imageFile),
                          )
                        : DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Theme.of(context).dividerColor,
                            ),
                            child:
                                const Icon(Icons.add_photo_alternate_outlined),
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
                        : DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Theme.of(context).dividerColor,
                            ),
                            child:
                                const Icon(Icons.add_photo_alternate_outlined),
                          ),
              ),
              onTap: () {
                showAdaptiveActionSheet<BottomSheetAction>(
                  context: context,
                  title: const Text('画像の選択'),
                  androidBorderRadius: 30,
                  actions: <BottomSheetAction>[
                    BottomSheetAction(
                      title: const Text('アルバムから選択'),
                      onPressed: () async {
                        if (await Permission.photos.status.isGranted ||
                            await Permission.photos.request().isGranted) {
                          await imageFileNotifier
                              .pickImage(ImageSource.gallery);
                          Navigator.pop(context);
                        } else {
                          await showDialog<CupertinoAlertDialog>(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                title: const Text('写真へのアクセスが許可されていません'),
                                content: const Text(
                                  '端末内の画像をレシピに保存するためには、アクセスの許可が必要です。',
                                ),
                                actions: <Widget>[
                                  CupertinoDialogAction(
                                    child: const Text('キャンセル'),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  const CupertinoDialogAction(
                                    onPressed: openAppSettings,
                                    child: Text('設定へ'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                    ),
                    BottomSheetAction(
                      title: const Text('カメラで撮影'),
                      onPressed: () async {
                        if (await Permission.camera.status.isGranted ||
                            await Permission.camera.request().isGranted) {
                          await imageFileNotifier.pickImage(ImageSource.camera);
                          Navigator.pop(context);
                        } else {
                          await showDialog<CupertinoAlertDialog>(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                title: const Text('カメラへのアクセスが許可されていません'),
                                content: const Text(
                                  'カメラで撮影した画像をレシピに保存するためには、アクセスの許可が必要です。',
                                ),
                                actions: <Widget>[
                                  CupertinoDialogAction(
                                    child: const Text('キャンセル'),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  const CupertinoDialogAction(
                                    onPressed: openAppSettings,
                                    child: Text('設定へ'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                    ),
                  ],
                  cancelAction: CancelAction(
                    title: const Text('キャンセル'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
            // 評価
            SizedBox(height: 8.h),
            Center(
              child: RatingBar.builder(
                initialRating: recipe.recipeGrade!,
                minRating: 0.5,
                allowHalfRating: true,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4).r,
                itemBuilder: (context, _) => const Icon(
                  Icons.star_rounded,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  recipe.recipeGrade = rating;
                },
              ),
            ),

            // 材料
            SizedBox(height: 8.h),
            Column(
              children: [
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.subtitle2!,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text('材料'),
                          SizedBox(width: 8.w),
                          SizedBox(
                            width: 24.w,
                            child: TextField(
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(
                                  left: 2,
                                  top: 4,
                                  bottom: 4,
                                ).r,
                                isDense: true,
                              ),
                              controller: recipe.forHowManyPeople == null
                                  ? null
                                  : TextEditingController(
                                      text: recipe.forHowManyPeople.toString(),
                                    ),
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
                            ),
                          ),
                          const Text('人分'),
                        ],
                      ),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.push<MaterialPageRoute<dynamic>>(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const IntroductionEditIngredientPage(),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.help_outline_rounded,
                          size: 20.sp,
                          color: Theme.of(context).hintColor,
                        ),
                        label: Text(
                          'ヘルプ',
                          style: TextStyle(color: Theme.of(context).hintColor),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                IngredientTextFieldWidget(
                  recipe: recipe,
                ),
              ],
            ),

            // 手順
            SizedBox(height: 8.h),
            Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '手順',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ),
                SizedBox(height: 8.h),
                const ProcedureTextFieldWidget(),
              ],
            ),
            // メモ
            SizedBox(height: 8.h),
            Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'メモ',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ),
                SizedBox(height: 8.h),
                TextField(
                  controller: TextEditingController(text: recipe.recipeMemo),
                  maxLength: 500,
                  maxLines: null,
                  onChanged: (value) {
                    recipe.recipeMemo = value;
                  },
                ),
                SizedBox(height: 48.h),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
