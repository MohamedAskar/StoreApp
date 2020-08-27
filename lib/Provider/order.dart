import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:store/models/cart_item.dart';
import 'package:store/models/order_item.dart';

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(
      {List<CartItem> cartItems,
      double total,
      String status,
      String paymentMethod}) {
    _orders.insert(
      0,
      OrderItem(
        id: UniqueKey().toString(),
        totalPrice: total,
        items: cartItems,
        dateTime: DateTime.now(),
        orderStatus: status,
        paymentMethod: paymentMethod,
      ),
    );
    notifyListeners();
  }

  OrderItem findById(String id) {
    return _orders.firstWhere((order) => order.id == id);
  }
}
