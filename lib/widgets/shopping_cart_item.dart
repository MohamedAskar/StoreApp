import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/Provider/cart.dart';

class ShoppingCartItem extends StatelessWidget {
  const ShoppingCartItem({
    Key key,
    @required this.id,
    @required this.name,
    @required this.size,
    @required this.price,
    @required this.image,
    @required this.quantity,
    @required this.itemId,
  }) : super(key: key);
  final String id;
  final String name;
  final String size;
  final double price;
  final String image;
  final int quantity;
  final String itemId;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Dismissible(
        direction: DismissDirection.endToStart,
        key: ValueKey(id),
        onDismissed: (direction) {
          Provider.of<Cart>(context, listen: false).removeItem(itemId);
        },
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(20.0),
          color: Colors.red,
          child: Icon(
            Icons.delete_outline,
            color: Colors.white,
            size: 40,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: deviceSize.width * 0.3,
              padding: const EdgeInsets.all(15),
              width: deviceSize.width / 2 - 30,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: Center(
                child: Image.network(image),
              ),
            ),
            SizedBox(
              width: 30,
            ),
            Container(
              width: deviceSize.width / 2 - 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    textScaleFactor: 0.8,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text.rich(TextSpan(
                      text: 'Size: ',
                      style: Theme.of(context).textTheme.bodyText1,
                      children: [
                        TextSpan(
                            text: 'EU $size',
                            style: Theme.of(context).textTheme.bodyText1)
                      ])),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '\$${(price * quantity)}',
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      Text.rich(TextSpan(
                          text: 'Qty: ',
                          style: Theme.of(context).textTheme.bodyText1,
                          children: [
                            TextSpan(
                                text: quantity.toString(),
                                style: Theme.of(context).textTheme.bodyText1)
                          ])),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
