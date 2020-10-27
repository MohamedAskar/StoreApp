import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:store/Provider/order.dart';
import 'package:store/widgets/account/order_item_widget.dart';

class OrderListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Order>(context).orders;
    return AnimationLimiter(
      child: ListView.builder(
          padding: const EdgeInsets.all(0),
          itemCount: orders.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 400),
              child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: ChangeNotifierProvider.value(
                        value: orders[index], child: OrderItemWidget()),
                  )),
            );
          }),
    );
  }
}
