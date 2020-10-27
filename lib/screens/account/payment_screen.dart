import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:store/Provider/payment_provider.dart';
import 'package:store/screens/account/add_payment_screen.dart';
import 'package:store/widgets/account/payment_item.dart';

class PaymentScreen extends StatelessWidget {
  final bool isCart;
  PaymentScreen({this.isCart = false});
  static const routeName = '/payment-screen';
  @override
  Widget build(BuildContext context) {
    final payments = Provider.of<PaymentProvider>(context).payments;
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      resizeToAvoidBottomPadding: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: double.infinity,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 40, 0, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Payment',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          Navigator.of(context).push(PageRouteBuilder(
                              transitionDuration:
                                  const Duration(milliseconds: 150),
                              opaque: false,
                              pageBuilder: (_, animation1, __) {
                                return SlideTransition(
                                    position: Tween(
                                            begin: Offset(1.0, 0.0),
                                            end: Offset(0.0, 0.0))
                                        .animate(animation1),
                                    child: AddPaymentScreen());
                              }));
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 142,
            child: SingleChildScrollView(
              child: FutureBuilder(
                  future: Provider.of<PaymentProvider>(context).fetchPayment(),
                  builder: (context, snapshot) {
                    return AnimationLimiter(
                      child: ListView.builder(
                          itemCount: payments.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(top: 16),
                          itemBuilder: (context, index) {
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 400),
                              child: SlideAnimation(
                                  verticalOffset: 50.0,
                                  child: FadeInAnimation(
                                    child: ChangeNotifierProvider.value(
                                      value: payments[index],
                                      child: PaymentItem(
                                        select: isCart,
                                      ),
                                    ),
                                  )),
                            );
                          }),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
