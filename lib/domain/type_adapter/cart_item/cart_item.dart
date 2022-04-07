import 'package:hive/hive.dart';

part 'cart_item.g.dart';

@HiveType(typeId: 1)
class CartItem {
  @HiveField(0)
  String id;

  @HiveField(1)
  bool isNeed;

  @HiveField(2)
  bool isBought;

  CartItem({required this.id, required this.isNeed, required this.isBought});
}

class CartItemBoxes {
  static Box<CartItem> getCartItems() => Hive.box<CartItem>('cartItems');
}
