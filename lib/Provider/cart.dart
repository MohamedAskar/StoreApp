import 'package:flutter/foundation.dart';
import 'package:store/models/cart_item.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  int get totalQuantity {
    int subtotal = 0;
    _items.forEach((key, cartItem) {
      subtotal += cartItem.quantity;
    });
    return subtotal;
  }

  void addItem(
      {String id,
      double price,
      String name,
      String image,
      int quantityWanted,
      String size}) {
    if (_items.containsKey(id)) {
      _items.update(
          id,
          (existingItem) => CartItem(
                id: existingItem.id,
                price: existingItem.price,
                name: existingItem.name,
                size: existingItem.size,
                quantity: existingItem.quantity + quantityWanted,
                image: existingItem.image,
              ));
    } else {
      _items.putIfAbsent(
          id,
          () => CartItem(
                id: id,
                price: price,
                name: name,
                quantity: quantityWanted,
                image: image,
                size: size,
              ));
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void removeSingleItem(String id) {
    if (!_items.containsKey(id)) {
      return;
    }
    if (_items[id].quantity > 1) {
      _items.update(
          id,
          (existingCardItem) => CartItem(
                id: existingCardItem.id,
                image: existingCardItem.image,
                size: existingCardItem.size,
                price: existingCardItem.price,
                quantity: existingCardItem.quantity - 1,
                name: existingCardItem.name,
              ));
    } else {
      _items.remove(id);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
