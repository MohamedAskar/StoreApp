import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:store/screens/auth/complete_profile_screen.dart';
import 'package:store/screens/auth/sign_in_screen.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/sign-up';
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  static const Pattern pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';

  bool _hidePassword = true;

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
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 70),
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
                    'Create an account.',
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
                            attribute: 'Full Name',
                            validators: [
                              FormBuilderValidators.minLength(6),
                              FormBuilderValidators.required(),
                            ],
                            keyboardType: TextInputType.name,
                            textCapitalization: TextCapitalization.words,
                            textInputAction: TextInputAction.next,
                            style: Theme.of(context).textTheme.bodyText1,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.person_outline,
                                color: Colors.black54,
                              ),
                              fillColor: Colors.black,
                              hintText: 'Enter your full name',
                              hintStyle: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                              labelText: 'Full name',
                              labelStyle: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          FormBuilderTextField(
                            attribute: 'Email',
                            validators: [
                              FormBuilderValidators.email(),
                              FormBuilderValidators.required(),
                            ],
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            style: Theme.of(context).textTheme.bodyText1,
                            autocorrect: false,
                            enableSuggestions: false,
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
                          SizedBox(
                            height: 30,
                          ),
                          FormBuilderTextField(
                            attribute: 'Password',
                            validators: [
                              FormBuilderValidators.required(),
                              FormBuilderValidators.minLength(8),
                              FormBuilderValidators.pattern(pattern,
                                  errorText:
                                      'Password should contain at least one digit. \n'
                                      'Password should contain at least 6 characters. \n'
                                      'Password should contain at least one upper case. \n'
                                      'Password should contain at least one lower case. \n'
                                      'Password should contain at least one special charactar.')
                            ],
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.visiblePassword,
                            style: Theme.of(context).textTheme.bodyText1,
                            obscureText: _hidePassword,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: Colors.black54,
                              ),
                              suffixIcon: InkWell(
                                child: Icon(
                                  Icons.remove_red_eye_outlined,
                                  color: Colors.black54,
                                ),
                                onTap: () {
                                  setState(() {
                                    _hidePassword = !_hidePassword;
                                  });
                                },
                              ),
                              fillColor: Colors.black,
                              hintText: 'Enter your Password',
                              hintStyle: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 40,
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
                          progress.dismiss();
                          Navigator.of(context)
                              .pushNamed(PhoneScreen.routeName, arguments: {
                            'email': formInputs['Email'],
                            'password': formInputs['Password'],
                            'fullName': formInputs['Full Name'],
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
                                      onPressed: () => Navigator.of(ctx).pop(),
                                    ),
                                  ],
                                );
                              });
                        }
                      }
                      progress.dismiss();
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      color: Colors.black,
                      child: Center(
                        child: Text(
                          'Getting Started',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Already have an account?',
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                      SizedBox(
                        width: 4,
                      ),
                      InkWell(
                          child: Text('Sign in',
                              style: Theme.of(context).textTheme.bodyText1),
                          onTap: () => Navigator.of(context).pushReplacement(
                              PageRouteBuilder(
                                  transitionDuration:
                                      const Duration(milliseconds: 150),
                                  opaque: false,
                                  pageBuilder: (_, animation1, __) {
                                    return SlideTransition(
                                        position: Tween(
                                                begin: Offset(1.0, 0.0),
                                                end: Offset(0.0, 0.0))
                                            .animate(animation1),
                                        child: SignInScreen());
                                  }))),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
