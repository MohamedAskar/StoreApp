import 'package:flutter/material.dart';
import 'package:store/models/address.dart';

class AddressProvider with ChangeNotifier {
  List<Address> _addressBook = [];

  List<Address> get addressBook {
    return [..._addressBook];
  }

  void addAddress(
      {String id,
      String city,
      String floor,
      String street,
      String fullName,
      String landmark,
      String building,
      String apartment,
      String governorate,
      String mobileNumber}) {
    _addressBook.insert(
        0,
        Address(
            id: id,
            city: city,
            floor: floor,
            street: street,
            landmark: landmark,
            fullName: fullName,
            building: building,
            apartment: apartment,
            governorate: governorate,
            mobileNumber: mobileNumber));
    notifyListeners();
  }

  Address findById(String id) {
    return _addressBook.firstWhere((address) => address.id == id);
  }
}
