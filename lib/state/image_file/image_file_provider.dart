import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'image_file_state.dart';

final imageFileNotifierProvider =
    StateNotifierProvider.autoDispose<ImageFileNotifier, File?>((ref) {
  return ImageFileNotifier();
});
