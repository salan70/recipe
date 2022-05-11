import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:hive/hive.dart';

part 'selected_flex_scheme_index.g.dart';

@HiveType(typeId: 3)
class SelectedFlexSchemeIndex {
  @HiveField(0)
  int selectedFlexSchemeIndex;

  SelectedFlexSchemeIndex({required this.selectedFlexSchemeIndex});
}

class SelectedFlexSchemeIndexBoxes {
  static Box<SelectedFlexSchemeIndex> getSelectedFlexSchemeIndex() =>
      Hive.box<SelectedFlexSchemeIndex>('selectedFlexSchemeIndex');
}
