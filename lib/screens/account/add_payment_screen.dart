import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:store/Provider/payment_provider.dart';
import 'package:store/models/payment.dart';

class AddPaymentScreen extends StatefulWidget {
  static const routeName = '/add-payment-screen';

  @override
  _AddPaymentScreenState createState() => _AddPaymentScreenState();
}

class _AddPaymentScreenState extends State<AddPaymentScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final expiryFormatter = MaskTextInputFormatter(mask: '##/##');
  final cardFormatter = MaskTextInputFormatter(mask: '#### #### #### ####');
  final FormFieldValidator<String> validator = (dynamic value) {
    if (value.isEmpty) {
      return null;
    }
    final components = value.split("/");
    if (components.length == 2) {
      final month = int.tryParse(components[0]);
      final year = int.tryParse(components[1]);
      if (month != null && year != null) {
        if (int.tryParse('20$year') >= DateTime.now().year &&
            int.tryParse('0$month') <= 12 &&
            month != 00) {
          return null;
        }
      }
    }
    return "Enter a valid date";
  };

  Payment _editedPayment = Payment(
      id: null,
      cvv: '',
      cardHolder: '',
      cardNumber: '',
      expiryMonth: '',
      expiryYear: '');
  var _isInit = true;
  var edit = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final paymentId = ModalRoute.of(context).settings.arguments as String;
      if (paymentId != null) {
        _editedPayment =
            Provider.of<PaymentProvider>(context).findById(paymentId);
        setState(() {
          edit = true;
        });
      }
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    final payment = Provider.of<PaymentProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: AppBar(
        brightness: Brightness.light,
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.white,
        leading: BackButton(
          onPressed: () {
            Navigator.maybePop(context);
          },
          color: Colors.black,
        ),
        title: Text(
          'Add Payment',
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
      body: ProgressHUD(
        barrierColor: Colors.transparent,
        child: Builder(builder: (context) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12, bottom: 12),
                    child: Text(
                      'Payment information',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.all(0),
                    shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                    color: Colors.white,
                    child: FormBuilder(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 6, 16, 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 16),
                            Row(
                              children: [
                                Flexible(
                                  child: FormBuilderTextField(
                                    //controller: _cardNumberController,
                                    initialValue: _editedPayment.cardNumber,
                                    inputFormatters: [cardFormatter],
                                    textInputAction: TextInputAction.next,
                                    validators: [
                                      FormBuilderValidators.required(),
                                    ],
                                    attribute: 'Card Number',
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(
                                        Icons.payment_outlined,
                                        color: Colors.black,
                                      ),
                                      fillColor: Colors.black,
                                      labelText: 'Card Number*',
                                      labelStyle: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                SizedBox(
                                  width: 100,
                                  child: FormBuilderTextField(
                                    initialValue: _editedPayment.cvv,
                                    textInputAction: TextInputAction.next,
                                    validators: [
                                      FormBuilderValidators.required(),
                                      FormBuilderValidators.numeric(),
                                      FormBuilderValidators.minLength(3),
                                      FormBuilderValidators.maxLength(3),
                                    ],
                                    attribute: 'CVV',
                                    obscureText: true,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(
                                        Icons.payment_outlined,
                                        color: Colors.black,
                                      ),
                                      fillColor: Colors.black,
                                      labelText: 'CVV*',
                                      labelStyle: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 14),
                            FormBuilderTextField(
                                attribute: 'Expiry Date',
                                inputFormatters: [expiryFormatter],
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                validators: [
                                  validator,
                                  FormBuilderValidators.required(),
                                ],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'MM/YY',
                                  hintStyle:
                                      const TextStyle(color: Colors.grey),
                                  fillColor: Colors.white,
                                  labelText: 'Expiry Date*',
                                  prefixIcon: Icon(
                                    Icons.date_range,
                                    color: Colors.black,
                                  ),
                                  labelStyle: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w600),
                                )),
                            SizedBox(
                              height: 14,
                            ),
                            FormBuilderTextField(
                              initialValue: _editedPayment.cardHolder,
                              textInputAction: TextInputAction.done,
                              validators: [
                                FormBuilderValidators.required(),
                                FormBuilderValidators.minLength(8),
                              ],
                              attribute: 'Card Holder',
                              textCapitalization: TextCapitalization.characters,
                              keyboardType: TextInputType.name,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(
                                  Icons.person_outline,
                                  color: Colors.black,
                                ),
                                fillColor: Colors.black,
                                hintText: 'Name as on card',
                                labelText: 'Card Holder Name*',
                                labelStyle: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: MaterialButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        final progress = ProgressHUD.of(context);
                        progress.showWithText('Loading...');
                        if (_formKey.currentState.saveAndValidate()) {
                          final formInputs = _formKey.currentState.value;
                          print(formInputs);

                          try {
                            await Future.delayed(Duration(seconds: 3),
                                () async {
                              if (edit) {
                                payment.updatePayment(
                                    _editedPayment.id,
                                    Payment(
                                      id: '',
                                      cvv: formInputs['CVV'],
                                      expiryMonth: formInputs['Expiry Date']
                                          .toString()
                                          .split('/')[0],
                                      expiryYear: formInputs['Expiry Date']
                                          .toString()
                                          .split('/')[1],
                                      cardHolder: formInputs['Card Holder'],
                                      cardNumber: formInputs['Card Number'],
                                    ));
                              } else {
                                payment.storePayment(
                                  cvv: formInputs['CVV'],
                                  expiryMonth: formInputs['Expiry Date']
                                      .toString()
                                      .split('/')[0],
                                  expiryYear: formInputs['Expiry Date']
                                      .toString()
                                      .split('/')[1],
                                  cardHolder: formInputs['Card Holder'],
                                  cardNumber: formInputs['Card Number'],
                                );
                              }
                              progress.dismiss();
                              Navigator.of(context).pop();
                            });
                          } on PlatformException catch (e) {
                            progress.dismiss();
                            print(e.message);
                          }
                        }
                        progress.dismiss();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width - 32,
                        padding: const EdgeInsets.all(16.0),
                        color: Colors.black,
                        child: Center(
                          child: Text(
                            edit ? 'Save Card' : 'Add new Card',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
