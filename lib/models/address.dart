import 'package:flutter/material.dart';

class Address {
  final String id;
  final String city;
  final String floor;
  final String street;
  final String fullName;
  final String landmark;
  final String building;
  final String apartment;
  final String governorate;
  final String mobileNumber;

  Address({
    this.id,
    this.floor,
    this.landmark,
    this.building,
    this.apartment,
    @required this.city,
    @required this.street,
    @required this.fullName,
    @required this.governorate,
    @required this.mobileNumber,
  });
}
