import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:store/models/payment.dart';

class PaymentProvider with ChangeNotifier {
  final Firestore _firestore = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Payment> _payments = [];

  List<Payment> get payments {
    return [..._payments];
  }

  void sortPayment(String id) {
    Payment selectedPayment = findById(id);
    _payments.removeWhere((payment) => payment.id == id);
    _payments.insert(0, selectedPayment);
    notifyListeners();
  }

  Future<void> storePayment({
    String cardHolder,
    String cardNumber,
    String expiryMonth,
    String expiryYear,
    String cvv,
  }) async {
    final user = await _auth.currentUser();
    final userRef = _firestore.collection('Users').document('${user.email}');
    final docRef = userRef.collection('Payments').document();

    docRef.setData({
      'cardHolder': cardHolder,
      'cardNumber': cardNumber,
      'expiryMonth': expiryMonth,
      'expiryYear': expiryYear,
      'CVV': cvv
    });
  }

  Future<void> fetchPayment() async {
    final List<Payment> loadedPayment = [];
    final user = await _auth.currentUser();
    final userRef = _firestore.collection('Users').document('${user.email}');

    await userRef
        .collection('Payments')
        .getDocuments()
        .then((QuerySnapshot snapshot) => snapshot.documents.forEach((payment) {
              loadedPayment.add(Payment(
                  id: payment.documentID,
                  cvv: payment.data['CVV'],
                  cardHolder: payment.data['cardHolder'],
                  cardNumber: payment.data['cardNumber'],
                  expiryYear: payment.data['expiryYear'],
                  expiryMonth: payment.data['expiryMonth']));
            }));
    _payments = loadedPayment;
    notifyListeners();
  }

  Future<void> updatePayment(String id, Payment newPayment) async {
    final user = await _auth.currentUser();
    final userRef = _firestore.collection('Users').document('${user.email}');
    await userRef.collection('Payments').document(id).updateData({
      'cardHolder': newPayment.cardHolder,
      'cardNumber': newPayment.cardNumber,
      'expiryMonth': newPayment.expiryMonth,
      'expiryYear': newPayment.expiryYear,
      'CVV': newPayment.cvv
    });
  }

  Future<void> removePayment(String id) async {
    final user = await _auth.currentUser();
    final userRef = _firestore.collection('Users').document('${user.email}');
    await userRef.collection('Payments').document(id).delete();
    notifyListeners();
  }

  Payment findById(String id) {
    return _payments.firstWhere((payment) => payment.id == id);
  }

  void clearPayments() {
    _payments = [];
    notifyListeners();
  }
}
