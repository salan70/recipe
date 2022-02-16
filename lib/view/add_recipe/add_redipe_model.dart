import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe/domain/recipe.dart';

class AddRecipeModel extends ChangeNotifier {
  AddRecipeModel(this.recipeName, this.imageUrl, this.recipeGrade,
      this.forHowManyPeople, this.recipeMemo, this.imageFile);

  String? recipeName;
  double? recipeGrade;
  int? forHowManyPeople;
  String? recipeMemo;
  String? imageUrl;
  File? imageFile;

  Future addRecipe(String uid, Recipe recipe, List<Ingredient> ingredientList,
      List<Procedure> procedureList) async {
    // 画像をStorageに保存
    if (recipe.imageFile != null) {
      imageFile = recipe.imageFile;
      final int timestamp = DateTime.now().microsecondsSinceEpoch;
      final String name = imageFile!.path.split('/').last;
      final String path = '${timestamp}_$name';
      final TaskSnapshot task = await FirebaseStorage.instance
          .ref()
          .child('users/$uid/recipeImages')
          .child(path)
          .putFile(imageFile!);

      imageUrl = await task.ref.getDownloadURL();
    }

    //レシピを保存
    DocumentReference docRef = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('recipes')
        .add({
      'recipeName': recipe.recipeName,
      'recipeGrade': recipe.recipeGrade,
      'forHowManyPeople': recipe.forHowManyPeople,
      'recipeMemo': recipe.recipeMemo,
      'imageUrl': imageUrl
    });

    print(docRef.id);

    // 材料を保存
    for (int i = 0; i < ingredientList.length; i++) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('recipes')
          .doc(docRef.id)
          .collection('ingredient')
          .add({
        'id': ingredientList[i].id,
        'name': ingredientList[i].name,
        'amount': ingredientList[i].amount,
        'unit': ingredientList[i].unit,
        'orderNum': i,
      });
    }

    // 手順を保存
    for (int i = 0; i < procedureList.length; i++) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('recipes')
          .doc(docRef.id)
          .collection('procedure')
          .add({
        'id': procedureList[i].id,
        'content': procedureList[i].content,
        'orderNum': i
      });
    }
  }
}

class ImageFileNotifier extends StateNotifier<ImageFile> {
  ImageFileNotifier() : super(ImageFile(null));

  File? imageFile;
  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      state = ImageFile(imageFile);
    }
  }
}
