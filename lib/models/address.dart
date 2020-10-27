import 'package:flutter/material.dart';

enum AddressType { Home, Office }

class Address with ChangeNotifier {
  final String id;
  final String city;
  final String floor;
  final String street;
  final String fullName;
  final String landmark;
  final String building;
  final AddressType type;
  final String governorate;
  final String mobileNumber;

  Address({
    this.floor,
    this.landmark,
    this.building,
    @required this.id,
    @required this.city,
    @required this.type,
    @required this.street,
    @required this.fullName,
    @required this.governorate,
    @required this.mobileNumber,
  });
}
