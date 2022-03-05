import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe/domain/recipe.dart';

/// AddRecipeRepositoryの作成によって不要？
// class AddRecipeModel extends ChangeNotifier {
//   AddRecipeModel(this.recipeName, this.imageUrl, this.recipeGrade,
//       this.forHowManyPeople, this.recipeMemo, this.imageFile);
//
//   String? recipeName;
//   double? recipeGrade;
//   int? forHowManyPeople;
//   String? recipeMemo;
//   String? imageUrl;
//   File? imageFile;
// }

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
