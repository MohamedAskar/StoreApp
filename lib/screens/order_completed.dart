import 'package:flutter/material.dart';

class OrderPlaced extends StatelessWidget {
  static const routeName = '/order-placed';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(
            Icons.done,
            size: 160,
            color: Colors.lightGreen,
          ),
          Center(
            child: Text(
              'Order Confirmed!',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  color: Colors.black),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              'Your order has been placed successfully!',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).popAndPushNamed('/');
            },
            child: Container(
              margin: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(25.0)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Text(
                    'Continue Shopping',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
