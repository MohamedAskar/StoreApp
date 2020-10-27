import 'package:store/models/address.dart';
import 'package:store/models/cart_item.dart';
import 'package:flutter/foundation.dart';
import 'package:store/models/payment.dart';

class OrderItem with ChangeNotifier {
  final String fireBaseID;
  final String id;
  final Address address;
  final double totalPrice;
  final DateTime dateTime;
  final String orderStatus;
  final List<CartItem> items;
  final Payment paymentMethod;
  final String email;
  final String coupon;

  OrderItem({
    this.fireBaseID,
    this.email,
    this.coupon,
    @required this.id,
    @required this.items,
    @required this.address,
    @required this.dateTime,
    @required this.totalPrice,
    @required this.orderStatus,
    @required this.paymentMethod,
  });
}
