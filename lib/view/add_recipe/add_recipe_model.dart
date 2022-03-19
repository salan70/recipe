import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe/domain/recipe.dart';

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
