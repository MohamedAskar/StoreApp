import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:store/models/address.dart';
//import 'package:http/http.dart' as http;

class AddressProvider with ChangeNotifier {
  final Firestore _firestore = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Address> _addressBook = [];

  List<Address> get addressBook {
    return [..._addressBook];
  }

  void sortAddresses(String id) {
    Address selectedAddress = findById(id);
    _addressBook.removeWhere((address) => address.id == id);
    _addressBook.insert(0, selectedAddress);
    notifyListeners();
  }

  Future<void> fetchAddress() async {
    final List<Address> loadedAddress = [];
    final user = await _auth.currentUser();
    final userRef = _firestore.collection('Users').document(user.email);

    await userRef
        .collection('Addresses')
        .getDocuments()
        .then((QuerySnapshot snapshot) => snapshot.documents.forEach((address) {
              loadedAddress.add(Address(
                  id: address.documentID,
                  city: address.data['city'],
                  type: (address.data['isHome'] == true)
                      ? AddressType.Home
                      : AddressType.Office,
                  street: address.data['street'],
                  fullName: address.data['fullName'],
                  governorate: address.data['governorate'],
                  mobileNumber: address.data['mobileNumber'],
                  building: address.data['building'],
                  floor: address.data['floor'],
                  landmark: address.data['landmark']));
            }));

    _addressBook = loadedAddress;

    notifyListeners();
  }

  Future<void> storeAddress(
      {String fullName,
      String mobileNumber,
      String governorate,
      String city,
      String street,
      String building,
      String floor,
      String landmark,
      bool isHome}) async {
    final user = await _auth.currentUser();
    final userRef = _firestore.collection('Users').document(user.email);
    final docRef = userRef.collection('Addresses').document();

    docRef.setData({
      'fullName': fullName,
      'mobileNumber': mobileNumber,
      'governorate': governorate,
      'city': city,
      'street': street,
      'building': building,
      'floor': floor,
      'landmark': landmark,
      'isHome': isHome,
    });
  }

  Future<void> updateAddress(String id, Address newAddress) async {
    final user = await _auth.currentUser();
    final userRef = _firestore.collection('Users').document(user.email);
    await userRef.collection('Addresses').document(id).updateData({
      'fullName': newAddress.fullName,
      'mobileNumber': newAddress.mobileNumber,
      'governorate': newAddress.governorate,
      'city': newAddress.city,
      'street': newAddress.street,
      'building': newAddress.building,
      'floor': newAddress.floor,
      'landmark': newAddress.landmark,
      'isHome': (newAddress.type == AddressType.Home) ? true : false,
    });
  }

  Future<void> removeAddress(String id) async {
    final user = await _auth.currentUser();
    final userRef = _firestore.collection('Users').document('${user.email}');
    await userRef.collection('Addresses').document(id).delete();
    notifyListeners();
  }

  Address findById(String id) {
    return _addressBook.firstWhere((address) => address.id == id);
  }

  void clearAddressBook() {
    _addressBook = [];
    notifyListeners();
  }
}
