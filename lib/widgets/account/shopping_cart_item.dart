import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/Provider/cart.dart';
import 'package:store/models/cart_item.dart';

class ShoppingCartItem extends StatefulWidget {
  final bool isCheckout;
  ShoppingCartItem({this.isCheckout});
  @override
  _ShoppingCartItemState createState() => _ShoppingCartItemState();
}

class _ShoppingCartItemState extends State<ShoppingCartItem> {
  int dropDownValue = 1;
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final cartItem = Provider.of<CartItem>(context, listen: false);
    final item = Row(
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
            child: CachedNetworkImage(
              imageUrl: cartItem.image,
              progressIndicatorBuilder: (context, url, progress) => Container(
                height: 60,
                child: Center(
                  child: CircularProgressIndicator(
                    value: progress.progress,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
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
                cartItem.name,
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
                        text: 'EU ${cartItem.size}',
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
                    '\$${(cartItem.price)}',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  Row(
                    children: [
                      Text(
                        'Qty: ',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      widget.isCheckout
                          ? Text(
                              cartItem.quantity.toString(),
                              style: Theme.of(context).textTheme.bodyText1,
                            )
                          : DropdownButton<int>(
                              elevation: 40,
                              style: Theme.of(context).textTheme.bodyText1,
                              value: cartItem.quantity,
                              items: [
                                DropdownMenuItem<int>(
                                  value: 1,
                                  child: new Text('1'),
                                ),
                                DropdownMenuItem<int>(
                                  value: 2,
                                  child: new Text('2'),
                                ),
                                DropdownMenuItem<int>(
                                  value: 3,
                                  child: new Text('3'),
                                ),
                                DropdownMenuItem<int>(
                                  value: 4,
                                  child: new Text('4'),
                                ),
                                DropdownMenuItem<int>(
                                  value: 5,
                                  child: new Text('5'),
                                ),
                                DropdownMenuItem<int>(
                                  value: 6,
                                  child: new Text('6'),
                                ),
                              ],
                              onChanged: (int newValue) async {
                                setState(() {
                                  dropDownValue = newValue;
                                });
                                final user =
                                    await FirebaseAuth.instance.currentUser();
                                final userCartRef = Firestore.instance
                                    .collection('Users')
                                    .document(user.email)
                                    .collection('CartItems');

                                final docRef =
                                    userCartRef.document(cartItem.id);
                                docRef.updateData({'quantity': dropDownValue});
                              },
                            )
                    ],
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
    return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: widget.isCheckout
            ? item
            : Dismissible(
                direction: DismissDirection.endToStart,
                key: ValueKey(cartItem.id),
                confirmDismiss: (direction) async {
                  await Provider.of<Cart>(context, listen: false)
                      .deleteCartItem(cartItem);
                  return;
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
                child: item));
  }
}
