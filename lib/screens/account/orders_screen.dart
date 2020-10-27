import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/Provider/order.dart';
import 'package:store/widgets/store/order_list.dart';
import 'package:store/widgets/store/store_appBar.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StoreAppBar('Orders'),
          Container(
            height: MediaQuery.of(context).size.height - 135,
            child: SingleChildScrollView(
              child: FutureBuilder(
                  future: Provider.of<Order>(context).fetchOrders(),
                  builder: (context, snapshot) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: OrderListView(),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
