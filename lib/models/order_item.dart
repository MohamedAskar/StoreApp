import 'package:store/models/cart_item.dart';
import 'package:flutter/foundation.dart';

class OrderItem {
  final String id;
  final double totalPrice;
  final List<CartItem> items;
  final DateTime dateTime;
  final String orderStatus;
  final String paymentMethod;

  OrderItem({
    @required this.id,
    @required this.totalPrice,
    @required this.items,
    @required this.dateTime,
    @required this.orderStatus,
    @required this.paymentMethod,
  });
}
