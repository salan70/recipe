import 'package:hive/hive.dart';

part 'customizations.g.dart';

@HiveType(typeId: 3)
class Customizations {
  Customizations({required this.index});

  @HiveField(0)
  int index;
}

class CustomizationsBoxes {
  static Box<Customizations> getCustomizations() =>
      Hive.box<Customizations>('customizations');
}
