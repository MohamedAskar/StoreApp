import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:store/models/address.dart';
import 'package:store/models/cart_item.dart';
import 'package:store/models/order_item.dart';
import 'package:store/models/payment.dart';

class Order with ChangeNotifier {
  final Firestore _firestore = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void storeOrder(
      {Address address,
      double totalPrice,
      String orderStatus,
      Payment payment,
      List<CartItem> orderItems,
      String token,
      String coupon}) async {
    final user = await _auth.currentUser();
    var adminRef = _firestore
        .collection('Admin')
        .document('Store')
        .collection('Orders')
        .document();
    // Adding Orders for Admin
    adminRef.setData({
      'coupon': coupon,
      'id': UniqueKey().toString(),
      'userEmail': user.email,
      'totalPrice': totalPrice,
      'dateTime': DateTime.now(),
      'orderStatus': orderStatus,
      'deviceToken': token,
    });
    adminRef.collection('OrderPayment').document().setData({
      'cardNumber': payment.cardNumber,
      'cardHolder': payment.cardHolder,
      'CVV': payment.cvv,
      'expiryMonth': payment.expiryMonth,
      'expiryYear': payment.expiryYear
    });
    adminRef.collection('OrderAddress').document().setData({
      'fullName': address.fullName,
      'mobileNumber': address.mobileNumber,
      'governorate': address.governorate,
      'city': address.city,
      'street': address.street,
      'building': address.building,
      'floor': address.floor,
      'landmark': address.landmark,
    });
    for (var item in orderItems) {
      adminRef.collection('OrderItems').document().setData({
        'name': item.name,
        'image': item.image,
        'size': item.size,
        'price': item.price,
        'quantity': item.quantity
      });
    }
  }

  Future<List<CartItem>> _fetchOrderItems(String documentId) async {
    List<CartItem> orderItems = [];
    final userRef = _firestore
        .collection('Admin')
        .document('Store')
        .collection('Orders')
        .document(documentId)
        .collection('OrderItems');

    await userRef.getDocuments().then((QuerySnapshot snapshot) {
      snapshot.documents.forEach(
        (cartItem) {
          orderItems.add(
            CartItem(
              id: cartItem.documentID,
              size: cartItem.data['size'],
              name: cartItem.data['name'],
              price: cartItem.data['price'],
              image: cartItem.data['image'],
              quantity: cartItem.data['quantity'],
            ),
          );
        },
      );
    });
    return orderItems;
  }

  Future<Address> _fetchOrderAddress(String documentId) async {
    List<Address> orderAddress = [];
    final userRef = _firestore
        .collection('Admin')
        .document('Store')
        .collection('Orders')
        .document(documentId)
        .collection('OrderAddress');

    await userRef.getDocuments().then(
          (QuerySnapshot snapshot) => snapshot.documents.forEach(
            (address) {
              orderAddress.add(
                Address(
                    id: null,
                    city: address.data['city'],
                    type: null,
                    street: address.data['street'],
                    fullName: address.data['fullName'],
                    governorate: address.data['governorate'],
                    mobileNumber: address.data['mobileNumber'],
                    building: address.data['building'],
                    floor: address.data['floor'],
                    landmark: address.data['landmark']),
              );
            },
          ),
        );
    return orderAddress[0];
  }

  Future<Payment> _fetchOrderPayment(String documentId) async {
    List<Payment> orderPayment = [];
    final userReference = _firestore
        .collection('Admin')
        .document('Store')
        .collection('Orders')
        .document(documentId)
        .collection('OrderPayment');

    await userReference.getDocuments().then(
        (QuerySnapshot snapshot) => snapshot.documents.forEach((paymentMethod) {
              orderPayment.add(Payment(
                  id: null,
                  cvv: paymentMethod.data['CVV'],
                  cardHolder: paymentMethod.data['cardHolder'],
                  cardNumber: paymentMethod.data['cardNumber'],
                  expiryYear: paymentMethod.data['expiryYear'],
                  expiryMonth: paymentMethod.data['expiryMonth']));
            }));
    return orderPayment[0];
  }

  Future<void> fetchOrders() async {
    final List<OrderItem> loadedOrders = [];

    final user = await _auth.currentUser();
    final userRef = _firestore
        .collection('Admin')
        .document('Store')
        .collection('Orders')
        .where('userEmail', isEqualTo: user.email);

    await userRef.getDocuments().then(
        (QuerySnapshot snapshot) => snapshot.documents.forEach((order) async {
              loadedOrders.add(OrderItem(
                fireBaseID: order.documentID,
                id: order.data['id'],
                email: null,
                coupon: order.data['coupon'],
                items: await _fetchOrderItems(order.documentID),
                dateTime: order.data['dateTime'].toDate(),
                totalPrice: order.data['totalPrice'],
                orderStatus: order.data['orderStatus'],
                address: await _fetchOrderAddress(order.documentID),
                paymentMethod: await _fetchOrderPayment(order.documentID),
              ));
            }));
    Future.delayed(
        Duration(
          seconds: 2,
        ), () {
      loadedOrders.sort((a, b) {
        return -a.dateTime.compareTo(b.dateTime);
      });
      _orders = loadedOrders;
    });
    notifyListeners();
  }

  OrderItem findById(String id) {
    return _orders.firstWhere((order) => order.id == id);
  }

  void clear() {
    _orders = [];
    notifyListeners();
  }
}
