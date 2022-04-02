import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:recipe/domain/type_adapter/cart_item.dart';

class CartItemRepository {
  Future putIsNeed(CartItem item, bool isNeed) async {
    final cartItem =
        CartItem(id: item.id, isNeed: isNeed, isBought: item.isBought);
    final box = Boxes.getCartItems();
    await box.put(item.id, cartItem);
  }

  Future putIsBought(CartItem item, bool isBought) async {
    final cartItem =
        CartItem(id: item.id, isNeed: item.isNeed, isBought: isBought);
    print(
        '${cartItem.id}, isNeed:${cartItem.isNeed}, isBought:${cartItem.isBought}');
    final box = Boxes.getCartItems();
    await box.put(item.id, cartItem);
  }

  CartItem getItem(String id) {
    final box = Boxes.getCartItems();
    final CartItem getBox = box.get(id,
        defaultValue: CartItem(id: id, isNeed: true, isBought: false))!;
    return getBox;
  }

  void deleteAll() async {
    final box = Boxes.getCartItems();
    box.delete('cartItems');
  }
}
