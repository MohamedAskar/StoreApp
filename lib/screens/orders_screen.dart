import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:store/Provider/order.dart';
import 'package:store/widgets/order_item_widget.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders-screen';
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Order>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                child: Column(
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
                      'Orders',
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            (orderData.orders.isEmpty)
                ? Center(
                    child: Text(
                      'You haven\'t order anything yet!',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  )
                : AnimationLimiter(
                    child: ListView.builder(
                        padding: const EdgeInsets.all(0),
                        itemCount: orderData.orders.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 400),
                            child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                    child: OrderItemWidget(
                                        orderData.orders[index]))),
                          );
                        }),
                  ),
          ],
        ),
      ),
    );
  }
}
