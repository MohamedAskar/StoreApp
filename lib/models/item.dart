import 'package:flutter/foundation.dart';

class Item with ChangeNotifier {
  final String id;
  final String name;
  final double price;
  final List<String> images;
  final String category;
  final int color;
  bool isFavorite;
  final List<String> sizes;

  Item({
    @required this.id,
    @required this.name,
    @required this.price,
    @required this.images,
    @required this.category,
    @required this.sizes,
    this.color = 0xFFF6F6F6,
    this.isFavorite = false,
  });

  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
