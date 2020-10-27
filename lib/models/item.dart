import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class Item with ChangeNotifier {
  final String id;
  final String name;
  final double price;
  final List<dynamic> images;
  final String category;
  final int color;
  bool isFavorite;
  final List<dynamic> sizes;
  final String description;

  Item({
    @required this.id,
    @required this.name,
    @required this.price,
    @required this.images,
    @required this.category,
    @required this.sizes,
    @required this.description,
    this.color = 0xFFF6F6F6,
    this.isFavorite = false,
  });

  void toggleFavorite() async {
    final user = await FirebaseAuth.instance.currentUser();
    final favRef = Firestore.instance
        .collection('Users')
        .document(user.email)
        .collection('Favorites')
        .document(id);
    var favItem = await favRef.get();
    if (favItem.exists) {
      favRef.delete();
      isFavorite = false;
    } else {
      favRef.setData({
        'name': name,
        'price': price,
        'category': category,
        'images': images.first,
      });
      isFavorite = true;
    }
    notifyListeners();
  }
}
