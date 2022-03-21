import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:riverpod/riverpod.dart';

class ImageFileNotifier extends StateNotifier<File> {
  ImageFileNotifier() : super(File(''));

  File? imageFile;
  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      state = imageFile!;
    }
  }
}
