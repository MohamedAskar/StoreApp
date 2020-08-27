import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:store/models/order_item.dart';
import 'package:store/screens/order_details_screen.dart';

class OrderItemWidget extends StatelessWidget {
  final OrderItem order;
  OrderItemWidget(this.order);
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.only(bottom: 16, top: 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order ${order.id.substring(1, order.id.length - 1).toUpperCase()}',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Text(
                          'Placed On ${DateFormat('MMM dd, yyyy').format(order.dateTime)}')
                    ],
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                            OrderDetailsScreen.routeName,
                            arguments: order.id);
                      },
                      child: Row(
                        children: [
                          Text(
                            'View Details',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 14),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          )
                        ],
                      ))
                ],
              ),
              Divider(),
              SizedBox(
                height: 6,
              ),
              ListView.builder(
                  padding: const EdgeInsets.all(0),
                  itemCount: order.items.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            order.items[index].image,
                            scale: 3,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order.items[index].name,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width - 200,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text.rich(TextSpan(
                                        text: 'Size: ',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14),
                                        children: [
                                          TextSpan(
                                            text:
                                                'EU ${order.items[index].size}',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w800,
                                                fontSize: 14),
                                          )
                                        ])),
                                    Text.rich(TextSpan(
                                        text: 'Qty: ',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14),
                                        children: [
                                          TextSpan(
                                            text: order.items[index].quantity
                                                .toString(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w800,
                                                fontSize: 14),
                                          )
                                        ])),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
              Divider(),
              SizedBox(
                height: 10,
              ),
              Text.rich(
                TextSpan(
                    text: 'Order status:  ',
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                        fontSize: 14),
                    children: [
                      TextSpan(
                        text: order.orderStatus.toUpperCase(),
                        style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w800,
                            fontSize: 16),
                      )
                    ]),
              ),
            ],
          ),
        ));
  }
}
