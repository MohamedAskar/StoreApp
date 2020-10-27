import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:store/Provider/cart.dart';
import 'package:store/widgets/account/shopping_cart_item.dart';

class CartList extends StatefulWidget {
  final bool isCheckout;
  CartList({this.isCheckout});
  @override
  _CartListState createState() => _CartListState();
}

class _CartListState extends State<CartList> {
  @override
  Widget build(BuildContext context) {
    final cartItems = Provider.of<Cart>(context).cartItems;
    return SizedBox(
      height: 155.0 * cartItems.length,
      child: AnimationLimiter(
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(0),
          itemCount: cartItems.length,
          itemBuilder: (context, i) => AnimationConfiguration.staggeredList(
            position: i,
            duration: const Duration(milliseconds: 400),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: ChangeNotifierProvider.value(
                  value: cartItems[i],
                  child: ShoppingCartItem(
                    isCheckout: widget.isCheckout,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
