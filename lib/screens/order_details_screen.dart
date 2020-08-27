import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:store/Provider/order.dart';

class OrderDetailsScreen extends StatelessWidget {
  static const routeName = '/order-details';
  @override
  Widget build(BuildContext context) {
    final orderId = ModalRoute.of(context).settings.arguments;
    final order = Provider.of<Order>(context).findById(orderId);
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: AppBar(
        brightness: Brightness.light,
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: BackButton(
          onPressed: () {
            Navigator.maybePop(context);
          },
          color: Colors.black,
        ),
        title: Image.asset(
          'assets/images/logo.png',
          height: 70,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Text(
                      'ORDER ID ${order.id.substring(1, order.id.length - 1).toUpperCase()}',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      'Placed On ${DateFormat('MMM dd, yyyy').format(order.dateTime)}'
                      ' at ${DateFormat('hh:mm aaa').format(order.dateTime)}',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Card(
                margin: const EdgeInsets.all(0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                color: Colors.white,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.location_on_outlined),
                          SizedBox(
                            width: 16,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Shipping Address',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              SizedBox(
                                height: 14,
                              ),
                              Text(
                                'Mohamed Askar',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black54),
                              ),
                              Text(
                                'Amer St, Tanta Qism 1, Gharbya, 31511',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black54),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Divider(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.call),
                          SizedBox(
                            width: 16,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mobile Number',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Text(
                                '+20 106 929 2154',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black54),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Card(
                margin: const EdgeInsets.all(0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                color: Colors.white,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(
                        color: Colors.green,
                        thickness: 4,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  order.orderStatus.toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16),
                                ),
                                Text.rich(
                                  TextSpan(
                                      text: 'Delivered on ',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14),
                                      children: [
                                        TextSpan(
                                          text: DateFormat('EEE, MMM dd')
                                              .format(order.dateTime
                                                  .add(Duration(days: 2))),
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 14),
                                        )
                                      ]),
                                )
                              ],
                            ),
                            Divider(),
                            SizedBox(
                              height: 8,
                            ),
                            AnimationLimiter(
                              child: ListView.builder(
                                  itemCount: order.items.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return AnimationConfiguration.staggeredList(
                                      position: index,
                                      duration:
                                          const Duration(milliseconds: 400),
                                      child: SlideAnimation(
                                        verticalOffset: 50,
                                        child: FadeInAnimation(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 12.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        order.items[index].name,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline3),
                                                    SizedBox(
                                                      height: 16,
                                                    ),
                                                    Text.rich(TextSpan(
                                                        text: 'Size: ',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 14),
                                                        children: [
                                                          TextSpan(
                                                            text:
                                                                'EU ${order.items[index].size}',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                fontSize: 14),
                                                          )
                                                        ])),
                                                    Text.rich(TextSpan(
                                                        text: 'Qty: ',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 14),
                                                        children: [
                                                          TextSpan(
                                                            text: order
                                                                .items[index]
                                                                .quantity
                                                                .toString(),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                fontSize: 14),
                                                          )
                                                        ])),
                                                  ],
                                                ),
                                                Image.network(
                                                  order.items[index].image,
                                                  scale: 3,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Card(
                margin: const EdgeInsets.all(0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                color: Colors.white,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Payment Method',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        Row(
                          children: [
                            Icon(Icons.payment_outlined),
                            SizedBox(
                              width: 16,
                            ),
                            Text(
                              'Card ending in 0123',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Card(
                margin: const EdgeInsets.all(0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                color: Colors.white,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order Summary',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Subtotal',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black54),
                                ),
                                Text(
                                  '\$${order.totalPrice}',
                                  style: Theme.of(context).textTheme.bodyText1,
                                )
                              ],
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Shipping Fee',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black54),
                                ),
                                Text(
                                  'Free',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Discount',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black54),
                                ),
                                Text(
                                  '\$0.0',
                                  style: Theme.of(context).textTheme.bodyText1,
                                )
                              ],
                            )
                          ],
                        ),
                        Divider(),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Estimated VAT',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54),
                            ),
                            Text(
                              '\$0.0',
                              style: Theme.of(context).textTheme.bodyText1,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            Text(
                              '\$${order.totalPrice}',
                              style: Theme.of(context).textTheme.headline3,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
