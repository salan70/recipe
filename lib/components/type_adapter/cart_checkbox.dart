import 'package:hive/hive.dart';

part 'cart_checkbox.g.dart';

@HiveType(typeId: 1)
class CartCheckBox {
  @HiveField(0)
  String id;

  @HiveField(1)
  bool isDone;

  CartCheckBox({required this.id, required this.isDone});
}
