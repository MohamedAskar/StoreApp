import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:store/Provider/addresses_provider.dart';
import 'package:store/Provider/cart.dart';
import 'package:store/Provider/order.dart';
import 'package:store/Provider/payment_provider.dart';
import 'package:store/models/address.dart';
import 'package:store/screens/store/order_completed.dart';
import 'package:store/widgets/store/cart_list.dart';
import 'package:store/widgets/store/store_appBar.dart';
// import 'package:stripe_payment/stripe_payment.dart';
// import 'package:stripe_payment/src/source.dart' as src;

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _controller = TextEditingController();

  final _formKey = GlobalKey<FormBuilderState>();

  bool isDiscount = false;

  var token;

  @override
  void initState() {
    super.initState();
    final fcm = FirebaseMessaging();
    token = fcm.getToken();
  }

  // Token _token;
  // PaymentMethod _paymentMethod;
  // src.Source _source;
  // final String _secretKey =
  //     'sk_test_51HbZLhEnTPezgIm7VQjLoZFaNRldhgf2FlvcvADfd4COvTbBAQIlxWA8uez5tLHEOfESdSVqhFT6ml8wNmIv81AY00U3y2htxK';
  // PaymentIntentResult _paymentIntentResult;
  // final CreditCard creditCard = CreditCard(
  //   number: '2601000541120123',
  //   expMonth: 02,
  //   expYear: 24,
  // );
  // String _error;
  // GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  // void getError(dynamic error) {
  //   _globalKey.currentState.showSnackBar(
  //     SnackBar(
  //       content: Text(error.toString()),
  //     ),
  //   );
  //   setState(() {
  //     _error = error;
  //   });
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   StripePayment.setOptions(StripeOptions(
  //       publishableKey:
  //           'pk_test_51HbZLhEnTPezgIm7U0oMWDrIO0rINgI11i8W8OALh1DhgfU4o1XcBfrGr1iI1dsdV34NNAiy5Zgm7QOFn3TznWvw00LEot6aki',
  //       androidPayMode: 'test',
  //       merchantId: 'Store test'));
  // }

  @override
  Widget build(BuildContext context) {
    final addressProvider = Provider.of<AddressProvider>(context);
    final paymentProvider = Provider.of<PaymentProvider>(context);
    final cartProvider = Provider.of<Cart>(context);
    var subAmount = Provider.of<Cart>(context).totalAmount;
    // ignore: unused_local_variable
    final fetchAddress = addressProvider.fetchAddress();
    // ignore: unused_local_variable
    final fetchPayment = paymentProvider.fetchPayment();
    final cart = cartProvider.cartItems;
    final address = addressProvider.addressBook;
    final payment = paymentProvider.payments;
    final size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Theme.of(context).cardColor,
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StoreAppBar('Checkout'),
              Container(
                height: size.height - 205,
                width: size.width,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Card(
                        color: Colors.white,
                        margin: const EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.zero)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'SHIP TO',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black45),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Row(
                                children: [
                                  Icon((address[0].type == AddressType.Home)
                                      ? Icons.home_work_outlined
                                      : Icons.location_city),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    (address[0].type == AddressType.Home)
                                        ? 'Home'
                                        : 'Office',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(address[0].fullName),
                              SizedBox(
                                height: 8,
                              ),
                              Text('${address[0].street}, '
                                  ' ${address[0].building}, '
                                  ' ${address[0].floor}, '
                                  '${address[0].city}.'),
                              Text(
                                '${address[0].governorate} Governorate',
                              ),
                              (address[0].landmark.isNotEmpty)
                                  ? Text(address[0].landmark)
                                  : SizedBox(),
                              SizedBox(
                                height: 8,
                              ),
                              Text(address[0].mobileNumber)
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Card(
                        margin: const EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'PAYMENT METHOD',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black45),
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
                                      'Card ending in ${payment[0].cardNumber.substring(15)}',
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
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'APPLY COUPON CODE OR GIFT CARD',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black45),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Card(
                              color: Colors.white,
                              margin: const EdgeInsets.all(0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.zero)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: FormBuilder(
                                        key: _formKey,
                                        child: FormBuilderTextField(
                                          attribute: 'Discount',
                                          textInputAction: TextInputAction.done,
                                          validators: [
                                            FormBuilderValidators.minLength(6)
                                          ],
                                          controller: _controller,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                              color: Colors.black),
                                          showCursor: true,
                                          textCapitalization:
                                              TextCapitalization.characters,
                                          keyboardType: TextInputType.text,
                                          autocorrect: true,
                                          enableSuggestions: true,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            fillColor: Colors.black,
                                            hintText: 'Enter your Coupon',
                                            hintStyle: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                            labelStyle: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            'APPLY',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          ),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            isDiscount = true;
                                          });
                                        })
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Card(
                        margin: const EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ORDER SUMMARY',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black45),
                                ),
                                SizedBox(
                                  height: 14,
                                ),
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Subtotal',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black54),
                                        ),
                                        Text(
                                          '\$$subAmount',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Discount',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black54),
                                        ),
                                        Text(
                                          isDiscount
                                              ? '-\$${subAmount * 0.2}'
                                              : '\$0.0',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Estimated VAT included (%14)',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black54),
                                    ),
                                    Text(
                                      isDiscount
                                          ? '\$${(subAmount * 0.2 * 0.14).toStringAsFixed(2)}'
                                          : '\$${(subAmount * 0.14).toStringAsFixed(2)}',
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total',
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                    Text(
                                      isDiscount
                                          ? '\$${subAmount * 0.8}'
                                          : '\$$subAmount',
                                      style:
                                          Theme.of(context).textTheme.headline3,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Card(
                        margin: const EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero),
                        color: Colors.white,
                        child: Container(
                          width: size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                child: Text(
                                  'REVIEW SHIPMENT',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black45),
                                ),
                              ),
                              FutureBuilder(
                                future:
                                    Provider.of<Cart>(context).fetchCartItems(),
                                builder: (context, snapshot) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, bottom: 0),
                                    child: CartList(
                                      isCheckout: true,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  width: size.width,
                  child: MaterialButton(
                    onPressed: () async {
                      Navigator.of(context).push(PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 150),
                          opaque: false,
                          pageBuilder: (_, animation1, __) {
                            return SlideTransition(
                                position: Tween(
                                        begin: Offset(1.0, 0.0),
                                        end: Offset(0.0, 0.0))
                                    .animate(animation1),
                                child: OrderPlaced());
                          }));
                      Provider.of<Order>(context, listen: false).storeOrder(
                          token: await token,
                          address: address[0],
                          payment: payment[0],
                          orderStatus: 'Placed',
                          totalPrice: Provider.of<Cart>(context, listen: false)
                              .totalAmount,
                          orderItems: cart);

                      Future.delayed(Duration(milliseconds: 150), () {
                        Provider.of<Cart>(context, listen: false).placeOrder();
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.only(top: 15, bottom: 15),
                      color: Colors.black,
                      child: Center(
                        child: Text(
                          'PAY NOW',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ))
            ]));
  }
}
