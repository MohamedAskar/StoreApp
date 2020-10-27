import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:store/Provider/admin.dart';
import 'package:store/models/order_item.dart';
import 'package:store/screens/account/order_details_screen.dart';

class OrderItemWidget extends StatelessWidget {
  final bool isAdmin;
  OrderItemWidget({this.isAdmin = false});
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

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final order = Provider.of<OrderItem>(context, listen: false);
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
                            arguments: {
                              'id': order.id,
                              'admin': isAdmin
                                  ? 'admin@store.com'
                                  : 'mohamedasker11@gmail.com'
                            });
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
                          Container(
                            height: 70,
                            width: 150,
                            child: CachedNetworkImage(
                              imageUrl: order.items[index].image,
                              progressIndicatorBuilder:
                                  (context, url, progress) => Container(
                                height: 60,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    value: progress.progress,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text.rich(TextSpan(
                      text: 'Order status:  ',
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                          fontSize: 14),
                      children: [
                        TextSpan(
                          text: order.orderStatus.toUpperCase(),
                          style: TextStyle(
                              color: toggleStatus(order.orderStatus),
                              fontWeight: FontWeight.w800,
                              fontSize: 16),
                        )
                      ])),
                  Visibility(
                    visible: isAdmin,
                    child: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) {
                            var size = MediaQuery.of(context).size;
                            return Dialog(
                              child: Container(
                                height: size.width * 0.84,
                                width: size.width * 0.65,
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Update Order',
                                      style:
                                          Theme.of(context).textTheme.headline3,
                                    ),
                                    FormBuilder(
                                      key: _formKey,
                                      child: FormBuilderRadioGroup(
                                        orientation:
                                            GroupedRadioOrientation.vertical,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                        attribute: 'Status',
                                        validators: [
                                          FormBuilderValidators.required()
                                        ],
                                        initialValue: order.orderStatus,
                                        options: [
                                          FormBuilderFieldOption(
                                            value: 'Placed',
                                            child: Text(
                                              'Placed',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 16),
                                            ),
                                          ),
                                          FormBuilderFieldOption(
                                            value: 'In Process',
                                            child: Text(
                                              'In Process',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 16),
                                            ),
                                          ),
                                          FormBuilderFieldOption(
                                            value: 'Shipped',
                                            child: Text(
                                              'Shipped',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 16),
                                            ),
                                          ),
                                          FormBuilderFieldOption(
                                            value: 'Delivered',
                                            child: Text(
                                              'Delivered',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 16),
                                            ),
                                          ),
                                          FormBuilderFieldOption(
                                            value: 'Cancelled',
                                            child: Text(
                                              'Cancelled',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
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
                                              if (_formKey.currentState
                                                  .saveAndValidate()) {
                                                final formInputs =
                                                    _formKey.currentState.value;
                                                print(formInputs);
                                                Provider.of<Admin>(context,
                                                        listen: false)
                                                    .updateOrder(
                                                        order.fireBaseID,
                                                        order,
                                                        formInputs['Status']);
                                                Future.delayed(
                                                    Duration(milliseconds: 100),
                                                    () {
                                                  Navigator.of(context).pop();
                                                });
                                              }
                                            },
                                            child: Text(
                                              'Yes',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1,
                                            )),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Row(
                        children: [
                          Icon(Icons.local_shipping_outlined),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            'Update order',
                            style: Theme.of(context).textTheme.bodyText1,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }
}
