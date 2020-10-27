import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:store/models/address.dart';
import 'package:store/models/cart_item.dart';
import 'package:store/models/order_item.dart';
import 'package:store/models/payment.dart';
import 'package:store/models/user.dart';

class Admin with ChangeNotifier {
  final Firestore _firestore = Firestore.instance;

  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  List<User> _users = [];

  List<User> get users {
    return [..._users];
  }

  int _numberOfUserOrders = 0;

  int get numberOfUserOrders {
    return _numberOfUserOrders;
  }

  Future<int> getUsers() async {
    int loadedUsers = 0;
    final adminRef =
        _firestore.collection('Admin').document('Store').collection('Users');

    await adminRef
        .getDocuments()
        .then((QuerySnapshot snapshot) => snapshot.documents.forEach((element) {
              loadedUsers += 1;
            }));
    return loadedUsers;
  }

  Future<int> getOrders() async {
    int loadedOrders = 0;
    final adminRef =
        _firestore.collection('Admin').document('Store').collection('Orders');

    await adminRef
        .getDocuments()
        .then((QuerySnapshot snapshot) => snapshot.documents.forEach((element) {
              loadedOrders += 1;
            }));
    return loadedOrders;
  }

  Future<int> getUserOrders(String email) async {
    int loadedUserOrders = 0;
    final adminRef = _firestore
        .collection('Admin')
        .document('Store')
        .collection('Orders')
        .where('userEmail', isEqualTo: email);

    await adminRef
        .getDocuments()
        .then((QuerySnapshot snapshot) => snapshot.documents.forEach((element) {
              loadedUserOrders += 1;
            }));
    return loadedUserOrders;
  }

  Future<void> fetchUsers() async {
    List<User> loadedUsers = [];
    final adminRef =
        _firestore.collection('Admin').document('Store').collection('Users');

    await adminRef
        .getDocuments()
        .then((QuerySnapshot snapshot) => snapshot.documents.forEach((user) {
              loadedUsers.add(User(
                  email: user.data['email'],
                  fullName: user.data['fullName'],
                  phoneNumber: user.data['phoneNumber'],
                  picture: user.data['photoUrl'],
                  createdDate: user.data['createdDate'].toDate(),
                  birthDate: user.data['birthDate'].toDate(),
                  gender: user.data['gender'],
                  token: user.data['token']));
            }));

    loadedUsers.sort((a, b) {
      return -a.createdDate.compareTo(b.createdDate);
    });
    _users = loadedUsers;
    notifyListeners();
  }

  Future<List<CartItem>> _fetchOrderItems(String documentId) async {
    List<CartItem> orderItems = [];
    final adminRef = _firestore
        .collection('Admin')
        .document('Store')
        .collection('Orders')
        .document(documentId);

    await adminRef.collection('OrderItems').getDocuments().then(
        (QuerySnapshot snapshot) => snapshot.documents.forEach((cartItem) {
              orderItems.add(CartItem(
                id: cartItem.documentID,
                size: cartItem.data['size'],
                name: cartItem.data['name'],
                price: cartItem.data['price'],
                image: cartItem.data['image'],
                quantity: cartItem.data['quantity'],
              ));
            }));
    return orderItems;
  }

  Future<Address> _fetchOrderAddress(String documentId) async {
    List<Address> orderAddress = [];
    final adminRef = _firestore
        .collection('Admin')
        .document('Store')
        .collection('Orders')
        .document(documentId);

    await adminRef.collection('OrderAddress').getDocuments().then(
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
    final adminRef = _firestore
        .collection('Admin')
        .document('Store')
        .collection('Orders')
        .document(documentId);
    await adminRef.collection('OrderPayment').getDocuments().then(
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

  Future<void> fetchOrdersForAdmin() async {
    final List<OrderItem> loadedOrders = [];
    final ordersForAdminRef =
        _firestore.collection('Admin').document('Store').collection('Orders');

    await ordersForAdminRef.getDocuments().then(
        (QuerySnapshot snapshot) => snapshot.documents.forEach((order) async {
              loadedOrders.add(OrderItem(
                fireBaseID: order.documentID,
                id: order.data['id'],
                email: order.data['userEmail'],
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

  Future<void> updateOrder(String id, OrderItem order, String status) async {
    await _firestore
        .collection('Admin')
        .document('Store')
        .collection('Orders')
        .document(id)
        .updateData({
      'orderStatus': status,
    });
  }

  void clear() {
    _orders = [];
    _users = [];
    _numberOfUserOrders = 0;
    notifyListeners();
  }
}
