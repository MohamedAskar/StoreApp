import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:store/main_screens/home_screen.dart';

enum AuthMode { SignUp, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth-screen';
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.black);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo2.png',
              width: 150,
            ),
            SizedBox(
              height: 20,
            ),
            AuthCard()
          ],
        ),
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  void _onButtonPressed(BuildContext context) async {
    await Navigator.of(context).pushReplacement(
        PageRouteBuilder(pageBuilder: (context, animation1, animation2) {
      return FadeTransition(opacity: animation1, child: StoreHome());
    }));
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.SignUp;
        _hidePassword = true;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
        _hidePassword = true;
      });
    }
  }

  AuthMode _authMode = AuthMode.Login;
  bool _hidePassword = true;
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      color: Colors.white,
      shadowColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(50.0),
            topRight: Radius.circular(50.0),
            bottomLeft: Radius.circular(50.0)),
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 16.0),
        height: (_authMode == AuthMode.Login) ? 340 : 410,
        width: deviceSize.width * 0.75,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: Text(
                '${_authMode == AuthMode.Login ? 'Welcome Back!' : 'Create an account.'}',
                style: TextStyle(
                    fontSize: _authMode == AuthMode.Login ? 30 : 26,
                    color: Colors.black),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              style: Theme.of(context).textTheme.bodyText1,
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.alternate_email_outlined,
                    color: Colors.black,
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.black54, width: 1.5)),
                  fillColor: Colors.black,
                  hintText: 'Enter your email',
                  labelText: 'E-Mail',
                  labelStyle: Theme.of(context).textTheme.bodyText1,
                  border: OutlineInputBorder(borderSide: BorderSide())),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              style: Theme.of(context).textTheme.bodyText1,
              obscureText: _hidePassword,
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: Colors.black,
                  ),
                  suffixIcon: InkWell(
                    child: Icon(
                      Icons.remove_red_eye_outlined,
                      color: Colors.black,
                    ),
                    onTap: () {
                      setState(() {
                        _hidePassword = !_hidePassword;
                      });
                    },
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.black54, width: 1.5)),
                  fillColor: Colors.black,
                  hintText: 'Enter your Password',
                  labelText: 'Password',
                  labelStyle: Theme.of(context).textTheme.bodyText1,
                  border: OutlineInputBorder(borderSide: BorderSide())),
            ),
            if (_authMode == AuthMode.SignUp) ...[
              SizedBox(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                style: Theme.of(context).textTheme.bodyText1,
                obscureText: _hidePassword,
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: Colors.black,
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.black54, width: 1.5)),
                    fillColor: Colors.black,
                    hintText: 'Enter your Password again',
                    labelText: 'Confirm Password',
                    labelStyle: Theme.of(context).textTheme.bodyText1,
                    border: OutlineInputBorder(borderSide: BorderSide())),
              )
            ],
            SizedBox(
              height: 10,
            ),
            Center(
              child: RaisedButton(
                onPressed: () => _onButtonPressed(context),
                color: Colors.black,
                child: Text(
                    '${_authMode == AuthMode.SignUp ? 'Sign up' : 'Login'}',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${_authMode == AuthMode.SignUp ? '' : 'Not a member?'}',
                    style: Theme.of(context).textTheme.bodyText1),
                SizedBox(
                  width: 4,
                ),
                InkWell(
                  child: Text(
                      '${_authMode == AuthMode.SignUp ? 'Already have an account?' : 'Register'}',
                      style: Theme.of(context).textTheme.bodyText1),
                  onTap: _switchAuthMode,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
