import 'package:flutter/material.dart';
import 'package:store/main_screens/home_screen.dart';

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
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Center(
            child: MaterialButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 150),
                    opaque: false,
                    pageBuilder: (_, animation1, __) {
                      return SlideTransition(
                          position: Tween(
                                  begin: Offset(1.0, 0.0),
                                  end: Offset(0.0, 0.0))
                              .animate(animation1),
                          child: StoreHome());
                    }));
              },
              child: Container(
                width: MediaQuery.of(context).size.width - 60,
                padding: const EdgeInsets.all(16.0),
                color: Colors.black,
                child: Center(
                  child: Text(
                    'Continue shopping',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
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
