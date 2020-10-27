import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/Provider/cart.dart';
import 'package:store/screens/account/address_book_screen.dart';
import 'package:store/widgets/store/cart_list.dart';
import 'package:store/widgets/store/store_appBar.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart-screen';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var token;

  @override
  void initState() {
    super.initState();
    final fcm = FirebaseMessaging();
    token = fcm.getToken();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cart = Provider.of<Cart>(context).cartItems;
    var totalQuantity = Provider.of<Cart>(context).totalQuantity;
    var subAmount = Provider.of<Cart>(context).totalAmount;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      resizeToAvoidBottomPadding: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StoreAppBar('Cart'),
          (cart.isNotEmpty)
              ? Container(
                  height: size.height - 225,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder(
                          future: Provider.of<Cart>(context).fetchCartItems(),
                          builder: (context, snapshot) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, bottom: 0),
                              child: CartList(
                                isCheckout: false,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                )
              : Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/box.png',
                        height: 150,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Nothing in your Cart yet!',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                ),
          SizedBox(
            height: 20,
          ),
          if (cart.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
              child: MaterialButton(
                onPressed: () {
                  Navigator.of(context).push(PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 150),
                      opaque: false,
                      pageBuilder: (_, animation1, __) {
                        return SlideTransition(
                            position: Tween(
                                    begin: Offset(1.0, 0.0),
                                    end: Offset(0.0, 0.0))
                                .animate(animation1),
                            child: AddressBookScreen(
                              isCart: true,
                            ));
                      }));

                  // showDialog(
                  //   context: context,
                  //   barrierDismissible: true,
                  //   builder: (context) {
                  //     return AlertDialog(
                  //       title: Text(
                  //         'Confirm Order',
                  //         style: Theme.of(context).textTheme.headline3,
                  //       ),
                  //       content: Text(
                  //         'Do you want to place this order?',
                  //         style: Theme.of(context).textTheme.bodyText1,
                  //       ),
                  //       actions: [
                  //         FlatButton(
                  //             onPressed: () {
                  //               Navigator.of(context).pop();
                  //             },
                  //             child: Text(
                  //               'No',
                  //               style: Theme.of(context)
                  //                   .textTheme
                  //                   .bodyText1,
                  //             )),
                  //         FlatButton(
                  //             onPressed: () async {
                  // Navigator.of(context).push(PageRouteBuilder(
                  //                               opaque: false,
                  //                               pageBuilder: (_, animation1, __) {
                  //                                 return FadeTransition(
                  //                                     opacity: animation1,
                  // child: OrderPlaced());
                  //                               }));
                  //               Provider.of<Order>(context,
                  //                       listen: false)
                  //                   .storeOrder(
                  //                       token: await token,
                  //                       address: address[0],
                  //                       payment: payment[0],
                  //                       orderStatus: 'Placed',
                  //                       totalPrice: Provider.of<Cart>(
                  //                               context,
                  //                               listen: false)
                  //                           .totalAmount,
                  //                       orderItems: cart);

                  //               Future.delayed(
                  //                   Duration(milliseconds: 150), () {
                  //                 Provider.of<Cart>(context,
                  //                         listen: false)
                  //                     .placeOrder();
                  //               });
                  //             },
                  //             child: Text(
                  //               'Yes',
                  //               style: Theme.of(context)
                  //                   .textTheme
                  //                   .bodyText1,
                  //             )),
                  //       ],
                  //     );
                  //   },
                  // );
                },
                child: Container(
                  padding: const EdgeInsets.only(top: 15, bottom: 15),
                  color: Colors.black,
                  child: Center(
                    child: Text(
                      'BUY $totalQuantity ITEMS FOR \$$subAmount',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white),
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
