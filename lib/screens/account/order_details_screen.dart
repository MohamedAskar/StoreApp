import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:store/Provider/admin.dart';
import 'package:store/Provider/order.dart';
import 'package:store/models/order_item.dart';

class OrderDetailsScreen extends StatefulWidget {
  static const routeName = '/order-details';

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  Color toggleStatus(String status) {
    Color color;
    if (status == 'Placed') {
      color = Colors.blueAccent;
    }
    if (status == 'In Process') {
      color = Colors.yellow[600];
    }
    if (status == 'Shipped') {
      color = Colors.green[300];
    }
    if (status == 'Delivered') {
      color = Colors.green;
    }
    if (status == 'Cancelled') {
      color = Colors.red;
    }
    return color;
  }

  var _isInit = true;
  OrderItem order;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final Map<String, String> arguments =
          ModalRoute.of(context).settings.arguments;
      if (arguments['admin'].contains('@store.com')) {
        order = Provider.of<Admin>(context).findById(arguments['id']);
      } else {
        order = Provider.of<Order>(context).findById(arguments['id']);
      }
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 32;
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
          height: 35,
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
                    ),
                    (order.email) != null
                        ? Text(
                            'Ordered by ${order.email}',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          )
                        : SizedBox()
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
                                order.address.fullName,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black54),
                              ),
                              Text(
                                '${order.address.street}, '
                                '${order.address.building}, '
                                '${order.address.floor}.',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black54),
                              ),
                              Text(
                                '${order.address.city}, '
                                '${order.address.governorate} Governorate.',
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
                                '${order.address.mobileNumber}',
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
                      if (order.orderStatus != 'Cancelled')
                        Container(
                          width: width,
                          child: Row(
                            children: [
                              SizedBox(
                                width: width / 4,
                                child: Divider(
                                  color: toggleStatus(order.orderStatus),
                                  thickness: 4,
                                  endIndent: 4,
                                ),
                              ),
                              SizedBox(
                                width: width / 4,
                                child: Divider(
                                  color: (order.orderStatus == 'In Process' ||
                                          order.orderStatus == 'Shipped' ||
                                          order.orderStatus == 'Delivered')
                                      ? toggleStatus(order.orderStatus)
                                      : null,
                                  thickness: 4,
                                  endIndent: 4,
                                ),
                              ),
                              SizedBox(
                                width: width / 4,
                                child: Divider(
                                  color: (order.orderStatus == 'Shipped' ||
                                          order.orderStatus == 'Delivered')
                                      ? toggleStatus(order.orderStatus)
                                      : null,
                                  thickness: 4,
                                  endIndent: 4,
                                ),
                              ),
                              SizedBox(
                                width: width / 4,
                                child: Divider(
                                  color: order.orderStatus == 'Delivered'
                                      ? toggleStatus(order.orderStatus)
                                      : null,
                                  thickness: 4,
                                ),
                              ),
                            ],
                          ),
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
                                      color: toggleStatus(order.orderStatus),
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16),
                                ),
                                Text.rich(
                                  TextSpan(
                                      text: (order.orderStatus == 'Delivered')
                                          ? 'Delivered on '
                                          : 'Arrives on ',
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
                                                Container(
                                                  height: 70,
                                                  width: 150,
                                                  child: CachedNetworkImage(
                                                    imageUrl: order
                                                        .items[index].image,
                                                    progressIndicatorBuilder: (context,
                                                            url,
                                                            downloadProgress) =>
                                                        CircularProgressIndicator(
                                                            value:
                                                                downloadProgress
                                                                    .progress),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
                                                  ),
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
                              'Card ending in ${order.paymentMethod.cardNumber.substring(12)}',
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
