import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:store/Provider/admin.dart';
import 'package:store/widgets/account/order_item_widget.dart';
import 'package:store/widgets/store/store_appBar.dart';

class AdminOrdersScreen extends StatelessWidget {
  static const routeName = 'admin-orders-screen';
  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Admin>(context).orders;
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
                  future: Provider.of<Admin>(context).fetchOrdersForAdmin(),
                  builder: (context, snapshot) {
                    return AnimationLimiter(
                        child: ListView.builder(
                      itemCount: orders.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(top: 16),
                      itemBuilder: (context, index) {
                        return AnimationConfiguration.staggeredList(
                            duration: const Duration(milliseconds: 600),
                            position: index,
                            child: SlideAnimation(
                              child: FadeInAnimation(
                                child: ChangeNotifierProvider.value(
                                  value: orders[index],
                                  child: OrderItemWidget(
                                    isAdmin: true,
                                  ),
                                ),
                              ),
                            ));
                      },
                    ));
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
