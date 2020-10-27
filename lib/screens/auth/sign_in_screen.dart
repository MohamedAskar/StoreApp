import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:store/Provider/auth.dart';
import 'package:store/main_screens/home_screen.dart';
import 'package:store/screens/admin/admin_screen.dart';
import 'package:store/screens/auth/forget_password.dart';
import 'package:store/screens/auth/sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  static const routeName = '/sign-in';
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  bool _hidePassword = true;
  final _auth = Auth();
  final String kAdmin = '@store.com';
  bool isAdmin = false;
  Future<String> token;

  @override
  void initState() {
    super.initState();
    final fcm = FirebaseMessaging();
    token = fcm.getToken();
  }

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
                    'Welcome Back!',
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
                          SizedBox(
                            height: 30,
                          ),
                          FormBuilderTextField(
                            attribute: 'Password',
                            validators: [FormBuilderValidators.required()],
                            textInputAction: TextInputAction.done,
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
                        ],
                      )),
                  SizedBox(
                    height: 40,
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context).push(PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 150),
                        opaque: false,
                        pageBuilder: (_, animation1, __) {
                          return SlideTransition(
                              position: Tween(
                                      begin: Offset(1.0, 0.0),
                                      end: Offset(0.0, 0.0))
                                  .animate(animation1),
                              child: ForgetPasswordScreen());
                        })),
                    child: Text('Forget your Password?',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        )),
                  ),
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
                          final authResult = await _auth.signIn(
                              formInputs['Email'].toString().trim(),
                              formInputs['Password'].toString().trim());
                          print(authResult.user.uid);
                          print(authResult.user.email);

                          progress.dismiss();
                          if (formInputs['Email'].toString().contains(kAdmin)) {
                            print('Admin');
                            Navigator.of(context).pushReplacement(
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
                                          child: AdminScreen());
                                    }));
                          } else {
                            Firestore.instance
                                .collection('Admin')
                                .document('Store')
                                .collection('Users')
                                .document(formInputs['Email'])
                                .updateData({'token': await token});
                            print('user');
                            Navigator.of(context).pushReplacementNamed(
                                StoreHome.routeName,
                                arguments: authResult.user);
                          }
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
                          'Sign in',
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
                      Text('Don\'t have an account?',
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                      SizedBox(
                        width: 4,
                      ),
                      InkWell(
                          child: Text('Sign up',
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
                                        child: SignUpScreen());
                                  }))),
                    ],
                  ),
                  SizedBox(height: 30),
                  Divider(),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
