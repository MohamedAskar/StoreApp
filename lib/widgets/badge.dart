import 'package:flutter/material.dart';
import 'package:store/screens/cart_screen.dart';

class Badge extends StatelessWidget {
  const Badge({
    Key key,
    @required this.value,
  }) : super(key: key);

  final int value;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
            icon: Icon(
              Icons.shopping_bag_outlined,
              color: Colors.black,
              size: 28,
            ),
            onPressed: () =>
                Navigator.of(context).pushNamed(CartScreen.routeName)),
        Positioned(
          left: 10,
          bottom: 12,
          child: Container(
            padding: EdgeInsets.all(2.0),
            // color: Theme.of(context).accentColor,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Theme.of(context).accentColor,
            ),
            constraints: BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),
            child: Text(
              value.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}
