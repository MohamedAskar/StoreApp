import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:store/models/cart_item.dart';

class Cart with ChangeNotifier {
  final Firestore _firestore = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<CartItem> _cartItems = [];
  double _totalAmount = 0.0;
  int _totalQuantity = 0;

  List<CartItem> get cartItems {
    return [..._cartItems];
  }

  double get totalAmount {
    return double.parse(_totalAmount.toStringAsFixed(2));
  }

  int get totalQuantity {
    return _totalQuantity;
  }

  Future<void> addCartItem(
      {double price,
      String id,
      String name,
      String image,
      int quantityWanted,
      String size}) async {
    final user = await _auth.currentUser();
    final userCartRef = _firestore
        .collection('Users')
        .document(user.email)
        .collection('CartItems');

    final docRef = userCartRef.document(id);

    final doc = await docRef.get();

    if (doc.exists) {
      if (doc.data['size'] == size) {
        docRef.updateData({
          'quantity': doc.data['quantity'] + quantityWanted,
          'size': size,
        });
      } else {
        docRef.setData({
          'price': price,
          'name': name,
          'image': image,
          'quantity': quantityWanted,
          'size': size,
        });
      }
    } else {
      docRef.setData({
        'price': price,
        'name': name,
        'image': image,
        'quantity': quantityWanted,
        'size': size,
      });
    }
  }

  Future<void> fetchCartItems() async {
    List<CartItem> loadedCartItems = [];
    double totalAmountLoaded = 0.0;
    int totalQuantityLoaded = 0;
    final user = await _auth.currentUser();
    final userRef = _firestore.collection('Users').document(user.email);

    await userRef.collection('CartItems').getDocuments().then(
        (QuerySnapshot snapshot) => snapshot.documents.forEach((cartItem) {
              loadedCartItems.add(CartItem(
                  id: cartItem.documentID,
                  image: cartItem.data['image'],
                  name: cartItem.data['name'],
                  price: cartItem.data['price'],
                  quantity: cartItem.data['quantity'],
                  size: cartItem.data['size']));

              totalAmountLoaded +=
                  (cartItem.data['price'] * cartItem.data['quantity']);
              totalQuantityLoaded += cartItem.data['quantity'];
            }));
    _cartItems = loadedCartItems;
    _totalAmount = totalAmountLoaded;
    _totalQuantity = totalQuantityLoaded;
    notifyListeners();
  }

  Future<void> placeOrder() async {
    final user = await _auth.currentUser();
    final cartItems = _firestore
        .collection('Users')
        .document(user.email)
        .collection('CartItems');
    cartItems.getDocuments().then((QuerySnapshot snapshot) {
      for (var cartItem in snapshot.documents) {
        cartItems.document(cartItem.documentID).delete();
      }
    });
  }

  Future<void> deleteCartItem(CartItem item) async {
    _cartItems.remove(item);
    final user = await _auth.currentUser();
    final userCartRef = _firestore.collection('Users').document(user.email);
    final docRef = userCartRef.collection('CartItems').document(item.id);

    docRef.delete();

    notifyListeners();
  }

  void clear() {
    _cartItems = [];
    notifyListeners();
  }
}
