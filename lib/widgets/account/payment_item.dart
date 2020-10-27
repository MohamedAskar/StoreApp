import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/Provider/payment_provider.dart';
import 'package:store/screens/account/add_payment_screen.dart';
import 'package:store/models/payment.dart';
import 'package:store/screens/store/checkout_screen.dart';

class PaymentItem extends StatelessWidget {
  const PaymentItem({
    this.select,
  });
  final bool select;

  @override
  Widget build(BuildContext context) {
    final payment = Provider.of<Payment>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        margin: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.payment),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'MasterCard',
                        style: Theme.of(context).textTheme.bodyText1,
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Visibility(
                        visible: select,
                        child: InkWell(
                            onTap: () {
                              Provider.of<PaymentProvider>(context,
                                      listen: false)
                                  .sortPayment(payment.id);
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
                                        child: CheckoutScreen());
                                  }));
                            },
                            child: Row(
                              children: [
                                Icon(Icons.person_pin_outlined),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  'Select',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                              ],
                            )),
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                AddPaymentScreen.routeName,
                                arguments: payment.id);
                          },
                          child: Row(
                            children: [
                              Icon(Icons.edit_outlined),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                'Edit',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ],
                          )),
                      SizedBox(
                        width: 20,
                      ),
                      InkWell(
                          onTap: () {
                            Provider.of<PaymentProvider>(context, listen: false)
                                .removePayment(payment.id);
                          },
                          child: Row(
                            children: [
                              Icon(Icons.delete_outline),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                'Delete',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ))
                    ],
                  ),
                ],
              ),
              Divider(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Card Holder'),
                      SizedBox(
                        height: 20,
                      ),
                      Text('Card Number'),
                      SizedBox(
                        height: 16,
                      ),
                      Text('Expiry Date')
                    ],
                  ),
                  SizedBox(
                    width: 60,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(payment.cardHolder),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                          'Card ending with ${payment.cardNumber.substring(12)}'),
                      SizedBox(
                        height: 16,
                      ),
                      Text('${payment.expiryMonth}/${payment.expiryYear}')
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
