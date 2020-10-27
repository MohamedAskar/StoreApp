import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:store/models/item.dart';

class ItemsProvider with ChangeNotifier {
  final Firestore _firestore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  List<Item> _storeItems = [];

  List<Item> get items {
    return [..._storeItems];
  }

  List<Item> _favItems = [];

  List<Item> get favItems {
    return [..._favItems];
  }

  Item findById(String id) {
    return _storeItems.firstWhere((item) => item.id == id);
  }

  void addItem(Item item) {
    _firestore.collection('Items').add({
      'name': item.name,
      'price': item.price,
      'category': item.category,
      'images': item.images,
      'sizes': item.sizes,
      'description': item.description,
    });
    notifyListeners();
  }

  Future<void> getFavItems() async {
    final List<Item> favItems = [];
    final user = await _auth.currentUser();
    final favoriteRef = _firestore
        .collection('Users')
        .document(user.email)
        .collection('Favorites');
    await favoriteRef.getDocuments().then(
          (value) => (QuerySnapshot snapshot) =>
              snapshot.documents.forEach((item) async {
                favItems.add(
                  Item(
                      id: item.documentID,
                      name: item.data['name'],
                      price: item.data['price'],
                      images: item.data['images'],
                      category: item.data['category'],
                      sizes: item.data['sizes'],
                      description: item.data['description'],
                      isFavorite: true),
                );
              }),
        );
    Future.delayed(Duration(seconds: 2), () {
      if (favItems.length > _favItems.length) _favItems = favItems;
    });
    notifyListeners();
  }

  Future<void> getItems() async {
    final List<Item> loadedItems = [];
    final user = await _auth.currentUser();
    final favoriteRef = _firestore
        .collection('Users')
        .document(user.email)
        .collection('Favorites');
    await _firestore.collection('Items').getDocuments().then(
          (QuerySnapshot snapshot) => snapshot.documents.forEach((item) async {
            var favItem = favoriteRef.document(item.documentID).get();
            loadedItems.add(
              Item(
                  id: item.documentID,
                  name: item.data['name'],
                  price: item.data['price'],
                  images: item.data['images'],
                  category: item.data['category'],
                  sizes: item.data['sizes'],
                  description: item.data['description'],
                  isFavorite: (await favItem).exists ? true : false),
            );
          }),
        );
    Future.delayed(Duration(seconds: 2), () {
      if (loadedItems.length > _storeItems.length) _storeItems = loadedItems;
    });
    notifyListeners();
  }

  Future<void> updateItem({String id, Item updatedItem}) async {
    await _firestore.collection('Items').document(id).updateData({
      'name': updatedItem.name,
      'price': updatedItem.price,
      'collection': updatedItem.category,
      'description': updatedItem.description,
      'images': updatedItem.images,
      'sizes': updatedItem.sizes,
    });
  }

  Future<void> deleteItem(String id) async {
    await _firestore.collection('Items').document(id).delete();
    notifyListeners();
  }

  void clear() {
    _storeItems = [];
    notifyListeners();
  }
}
