import 'package:flutter/material.dart';

class WishListScreen extends StatefulWidget {
  static const routeName = '/wishlist-screen';
  @override
  _WishListScreenState createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Center(
              child: Image.asset(
                'assets/images/box.png',
                height: 80,
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Center(
              child: Column(
                children: [
                  Text(
                    'There is no items in your WishList yet!',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Text(
                    'There\'s nothing you like?',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}
