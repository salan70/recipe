import 'package:hive/hive.dart';

part 'cart_item.g.dart';

@HiveType(typeId: 1)
class CartItem {
  @HiveField(0)
  String id;

  @HiveField(1)
  bool isInBuyList;

  @HiveField(2)
  bool isChecked;

  CartItem(
      {required this.id, required this.isInBuyList, required this.isChecked});
}

class CartItemBoxes {
  static Box<CartItem> getCartItems() => Hive.box<CartItem>('cartItems');
}
