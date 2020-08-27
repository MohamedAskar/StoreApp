import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:store/Provider/cart.dart';
import 'package:store/Provider/order.dart';
import 'package:store/screens/order_completed.dart';
import 'package:store/widgets/shopping_cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart-screen';
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: size.height - 180,
                child: SingleChildScrollView(
                  child: Padding(
                      padding:
                          const EdgeInsets.only(left: 20, top: 40, bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.maybePop(context);
                                },
                                child: Icon(
                                  Icons.clear_outlined,
                                  size: 25,
                                ),
                              ),
                              SizedBox(
                                height: 18,
                              ),
                              Text(
                                'Cart',
                                style: Theme.of(context).textTheme.headline1,
                              ),
                            ],
                          ),
                          (cart.items.isEmpty)
                              ? Center(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 50,
                                      ),
                                      Image.asset(
                                        'assets/images/box.png',
                                        height: 150,
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Text(
                                        'Nothing in your Cart yet!',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                    ],
                                  ),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 165.0 * cart.items.length,
                                      child: AnimationLimiter(
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: cart.items.length,
                                          itemBuilder: (context, i) =>
                                              AnimationConfiguration
                                                  .staggeredList(
                                            position: i,
                                            duration: const Duration(
                                                milliseconds: 400),
                                            child: SlideAnimation(
                                              verticalOffset: 50.0,
                                              child: FadeInAnimation(
                                                child: ShoppingCartItem(
                                                  id: cart.items.values
                                                      .toList()[i]
                                                      .id,
                                                  name: cart.items.values
                                                      .toList()[i]
                                                      .name,
                                                  size: cart.items.values
                                                      .toList()[i]
                                                      .size,
                                                  price: cart.items.values
                                                      .toList()[i]
                                                      .price,
                                                  image: cart.items.values
                                                      .toList()[i]
                                                      .image,
                                                  quantity: cart.items.values
                                                      .toList()[i]
                                                      .quantity,
                                                  itemId: cart.items.keys
                                                      .toList()[i],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Divider(),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Shipping address',
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Icon(
                                              Icons.local_shipping_outlined,
                                              size: 30,
                                            ),
                                            SizedBox(
                                              width: 30,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Amer St, Tanta Qism 1',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1,
                                                ),
                                                Text(
                                                  'Gharbya, 31511',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1,
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 20),
                                          child: OutlineButton(
                                            onPressed: () {},
                                            child: Text(
                                              'Change',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1,
                                            ),
                                            color: Colors.black,
                                            focusColor: Colors.black,
                                            borderSide: BorderSide(
                                                color: Colors.black, width: 2),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                          ),
                                        )
                                      ],
                                    ),
                                    Divider(),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20.0),
                                      child: Text(
                                        'Payment Method',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Icon(
                                              Icons.payment_outlined,
                                              size: 30,
                                            ),
                                            SizedBox(
                                              width: 30,
                                            ),
                                            Text(
                                              '****  ****  ****  1234',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1,
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 20),
                                          child: OutlineButton(
                                            onPressed: () {},
                                            child: Text(
                                              'Change',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1,
                                            ),
                                            color: Colors.black,
                                            focusColor: Colors.black,
                                            borderSide: BorderSide(
                                                color: Colors.black, width: 2),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                )
                        ],
                      )),
                ),
              ),
            ],
          ),
          (cart.items.isEmpty)
              ? SizedBox()
              : Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      width: size.width,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    color: Colors.grey),
                              ),
                              Text(
                                '\$${cart.totalAmount}',
                                style: Theme.of(context).textTheme.headline3,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          InkWell(
                            onTap: () {
                              if (cart.items.isNotEmpty) {
                                showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(
                                        'Confirm Order',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3,
                                      ),
                                      content: Text(
                                        'Do you want to place this order?',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                      actions: [
                                        FlatButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              'No',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1,
                                            )),
                                        FlatButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .popAndPushNamed(
                                                      OrderPlaced.routeName);
                                              Provider.of<Order>(context,
                                                      listen: false)
                                                  .addOrder(
                                                      cartItems: cart
                                                          .items.values
                                                          .toList(),
                                                      total: cart.totalAmount,
                                                      status: 'Delivered',
                                                      paymentMethod:
                                                          'Cash on Delivery');
                                              Timer(
                                                  Duration(
                                                    seconds: 3,
                                                  ), () {
                                                cart.clear();
                                              });
                                            },
                                            child: Text(
                                              'Yes',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1,
                                            )),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.only(top: 15, bottom: 15),
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(15.0)),
                              child: Center(
                                child: Text(
                                  'Pay Now',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )
        ],
      ),
    );
  }
}
