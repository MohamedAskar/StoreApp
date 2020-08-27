import 'package:flutter/cupertino.dart';

class CartItem {
  final String id;
  final String size;
  final String name;
  final int quantity;
  final double price;
  final String image;

  CartItem({
    @required this.id,
    @required this.size,
    @required this.name,
    @required this.price,
    @required this.image,
    @required this.quantity,
  });
}
