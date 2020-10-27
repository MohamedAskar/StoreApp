import 'package:flutter/material.dart';

class User with ChangeNotifier {
  final String email;
  final String fullName;
  final String phoneNumber;
  final String gender;
  final DateTime birthDate;
  final String picture;
  final DateTime createdDate;
  final String token;

  User({
    @required this.email,
    @required this.fullName,
    @required this.phoneNumber,
    @required this.picture,
    @required this.createdDate,
    @required this.token,
    this.gender,
    this.birthDate,
  });
}
