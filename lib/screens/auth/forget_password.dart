import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:store/Provider/auth.dart';

class ForgetPasswordScreen extends StatefulWidget {
  static const routeName = '/forget-password';
  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  final _auth = Auth();

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    return Scaffold(
        backgroundColor: Colors.white,
        body: ProgressHUD(
          barrierColor: Colors.transparent,
          child: Builder(builder: (context) {
            return SingleChildScrollView(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 70),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          height: 40,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).maybePop();
                          },
                          child: Icon(
                            Icons.clear_outlined,
                            size: 25,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      'Reset your Password',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    FormBuilder(
                        key: _formKey,
                        child: Column(
                          children: [
                            FormBuilderTextField(
                              attribute: 'Email',
                              validators: [
                                FormBuilderValidators.email(),
                                FormBuilderValidators.required(),
                              ],
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              enableSuggestions: false,
                              textInputAction: TextInputAction.next,
                              style: Theme.of(context).textTheme.bodyText1,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.alternate_email_outlined,
                                  color: Colors.black54,
                                ),
                                fillColor: Colors.black,
                                hintText: 'Enter your email',
                                hintStyle: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                                labelText: 'E-Mail',
                                labelStyle: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        )),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                        '• An email will be sent to the entered email with a link to submit your new password.'),
                    SizedBox(
                      height: 20,
                    ),
                    MaterialButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        final progress = ProgressHUD.of(context);
                        progress.showWithText('Loading...');
                        if (_formKey.currentState.saveAndValidate()) {
                          final formInputs = _formKey.currentState.value;
                          print(formInputs);
                          try {
                            await _auth.forgetPassword(formInputs['Email']);
                            Future.delayed(Duration(seconds: 2), () {
                              progress.dismiss();
                              Navigator.of(context).pop();
                            });
                          } on PlatformException catch (e) {
                            progress.dismiss();
                            showDialog(
                                context: context,
                                builder: (ctx) {
                                  return AlertDialog(
                                    title: Text('An error occurred!',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3),
                                    content: Text(
                                      e.message,
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('Okay',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1),
                                        onPressed: () =>
                                            Navigator.of(ctx).pop(),
                                      ),
                                    ],
                                  );
                                });
                          }
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16.0),
                        color: Colors.black,
                        child: Center(
                          child: Text(
                            'Send Email',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ));
  }
}
