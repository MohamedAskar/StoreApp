import 'package:flutter/cupertino.dart';

class Payment with ChangeNotifier {
  final String id;
  final String cvv;
  final String cardHolder;
  final String cardNumber;
  final String expiryMonth;
  final String expiryYear;

  Payment({
    @required this.id,
    @required this.cvv,
    @required this.cardHolder,
    @required this.cardNumber,
    @required this.expiryYear,
    @required this.expiryMonth,
  });
}
