import 'package:hive/hive.dart';

part 'customizations.g.dart';

@HiveType(typeId: 3)
class Customizations {
  @HiveField(0)
  int index;

  Customizations({required this.index});
}

class CustomizationsBoxes {
  static Box<Customizations> getCustomizations() =>
      Hive.box<Customizations>('customizations');
}
