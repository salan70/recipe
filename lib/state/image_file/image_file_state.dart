import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod/riverpod.dart';

class ImageFileNotifier extends StateNotifier<File?> {
  ImageFileNotifier() : super(null);

  File? imageFile;
  CroppedFile? croppedFile;
  final picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      croppedFile = await _cropImage();
      if (croppedFile != null) {
        state = File(croppedFile!.path);
      }
    }
  }

  Future<CroppedFile?> _cropImage() async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile!.path,
      uiSettings: [
        AndroidUiSettings(
          statusBarColor: Colors.black,
          toolbarTitle: '',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          backgroundColor: Colors.black,
          cropFrameColor: Colors.transparent,
          showCropGrid: false,
          hideBottomControls: true,
          initAspectRatio: CropAspectRatioPreset.original,
        ),
        IOSUiSettings(
          hidesNavigationBar: true,
          aspectRatioPickerButtonHidden: true,
          doneButtonTitle: '完了',
          cancelButtonTitle: '戻る',
        ),
      ],
    );
    return croppedFile;
  }
}
